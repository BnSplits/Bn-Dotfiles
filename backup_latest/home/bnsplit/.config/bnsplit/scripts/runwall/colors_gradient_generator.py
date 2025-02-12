import sys
import os
import re
import colorsys
import subprocess
from datetime import datetime

try:
    import json5  # For JSONC support
except ImportError:
    print("\033[1;31m[ERROR] Missing required dependency: json5\033[0m")
    print("Install with: pip install json5")
    sys.exit(1)


# --------------------------
# Utility Functions
# --------------------------
def print_header(message):
    print(f"\n\033[1;34m[{datetime.now().strftime('%H:%M:%S')}] {message}\033[0m")


def print_info(message):
    print(f"\033[1;32m[INFO]\033[0m {message}")


def print_warning(message):
    print(f"\033[1;33m[WARNING]\033[0m {message}")


def print_success(message):
    print(f"\033[1;32m[SUCCESS]\033[0m {message}")


# --------------------------
# Color Conversion Functions
# --------------------------
def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip("#")
    if len(hex_color) != 6:
        raise ValueError("Invalid hex color")
    return tuple(int(hex_color[i : i + 2], 16) for i in (0, 2, 4))


def rgb_to_hex(r, g, b, strip_hash=False):
    hex_color = f"#{r:02x}{g:02x}{b:02x}".upper()
    return hex_color[1:] if strip_hash else hex_color


# --------------------------
# Color Generation
# --------------------------
def generate_colors(hex_color):
    print_header("Generating color spectrum")
    print_info(f"Base color: {hex_color}")

    r, g, b = hex_to_rgb(hex_color)
    h, l, s = colorsys.rgb_to_hls(r / 255, g / 255, b / 255)
    colors = []

    # --------------------------
    # Color Brightness
    # --------------------------
    min_lightness = 0.08
    max_lightness = 1

    print_info(f"Lightness range: {min_lightness*100:.0f}% - {max_lightness*100:.0f}%")

    for i in range(16):
        new_l = min_lightness + (i / 15) * (max_lightness - min_lightness)
        rgb = colorsys.hls_to_rgb(h, new_l, s)
        r_new = min(255, max(0, int(round(rgb[0] * 255))))
        g_new = min(255, max(0, int(round(rgb[1] * 255))))
        b_new = min(255, max(0, int(round(rgb[2] * 255))))
        colors.append((r_new, g_new, b_new))

    # Validate color range
    first_color = colors[0]
    last_color = colors[-1]
    if first_color == (0, 0, 0):
        print_warning("First color is pure black (should be avoided)")
    if last_color == (255, 255, 255):
        print_warning("Last color is pure white (should be avoided)")

    print_info(f"First generated color: {rgb_to_hex(*first_color)} {first_color}")
    print_info(f"Last generated color: {rgb_to_hex(*last_color)} {last_color}")

    return colors


# --------------------------
# Template Processing
# --------------------------
def replace_placeholders(content, colors):
    pattern = re.compile(
        r"\{\{col\.(\d+)\.(hex|hex_stripped|rgb|rgba)(?:\s*\|\s*(.+?))?\}\}"
    )
    replacements = 0
    errors = 0

    def replacer(match):
        nonlocal replacements, errors
        index = int(match.group(1)) - 1
        fmt = match.group(2)
        modifiers = match.group(3) or ""

        if index < 0 or index >= 16:
            errors += 1
            print_warning(f"Invalid color index: {index+1} (must be 1-16)")
            return f"{{{{ INVALID INDEX {index+1} }}}}"

        replacements += 1
        r, g, b = colors[index]
        alpha = 1.0

        for modifier in modifiers.split("|"):
            modifier = modifier.strip()
            if "alpha" in modifier:
                alpha = float(modifier.split(":")[1].strip())

        if fmt == "hex":
            return rgb_to_hex(r, g, b)
        elif fmt == "hex_stripped":
            return rgb_to_hex(r, g, b, strip_hash=True)
        elif fmt == "rgb":
            return f"rgb({r}, {g}, {b})"
        elif fmt == "rgba":
            return f"rgba({r},{g},{b},{alpha:g})"
        return ""

    new_content = pattern.sub(replacer, content)
    print_info(f"Made {replacements} replacements with {errors} errors")
    return new_content


# --------------------------
# Config Loading
# --------------------------
def load_jsonc(file_path):
    print_info(f"Loading JSONC config: {file_path}")
    try:
        with open(file_path, "r") as f:
            return json5.load(f)
    except json5.JSON5DecodeError as e:
        print(f"\033[1;31m[ERROR] JSONC parse error: {str(e)}\033[0m")
        sys.exit(1)
    except Exception as e:
        print(f"\033[1;31m[ERROR] File error: {str(e)}\033[0m")
        sys.exit(1)


# --------------------------
# Main Function
# --------------------------
def main():
    if len(sys.argv) < 3:
        print("Usage: python script.py <hex_color> <config.jsonc>")
        print("Note: Config file must be in JSONC format (supports comments)")
        sys.exit(1)

    print_header("Starting color generation process")
    base_color = sys.argv[1].lstrip("#")
    config_file = sys.argv[2]
    print_info(f"Input color: #{base_color}")
    print_info(f"Using config file: {config_file}")

    try:
        colors = generate_colors(f"#{base_color}")
    except ValueError as e:
        print(f"\033[1;31m[ERROR] {str(e)}\033[0m")
        sys.exit(1)

    # Load JSONC configuration
    configs = load_jsonc(config_file)

    print_header(f"Processing {len(configs)} template configurations")

    for cfg in configs:
        print_header(f"Processing '{cfg['name']}' template")
        print_info(f"Template: {cfg['template']}")
        print_info(f"Output: {cfg['output']}")

        template_path = os.path.expanduser(cfg["template"])
        output_path = os.path.expanduser(cfg["output"])

        try:
            with open(template_path, "r") as f:
                content = f.read()
        except FileNotFoundError:
            print(f"\033[1;31m[ERROR] Template file not found: {template_path}\033[0m")
            continue

        processed = replace_placeholders(content, colors)

        output_dir = os.path.dirname(output_path)
        if not os.path.exists(output_dir):
            print_info(f"Creating directory: {output_dir}")
            os.makedirs(output_dir, exist_ok=True)

        try:
            with open(output_path, "w") as f:
                f.write(processed)
            print_success(f"File created: {output_path} ({len(processed)} bytes)")
        except IOError as e:
            print(f"\033[1;31m[ERROR] Failed to write output: {str(e)}\033[0m")
            continue

        if "command" in cfg:
            print_info(f"Executing post-command: {cfg['command']}")
            try:
                subprocess.run(cfg["command"], shell=True, check=True)
                print_success("Command executed successfully")
            except subprocess.CalledProcessError as e:
                print(f"\033[1;31m[ERROR] Command failed: {str(e)}\033[0m")

    print_header("Process completed")


if __name__ == "__main__":
    main()
