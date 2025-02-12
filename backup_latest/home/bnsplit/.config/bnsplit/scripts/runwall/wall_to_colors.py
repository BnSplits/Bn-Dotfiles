import sys
import os
import numpy as np
from PIL import Image
import hashlib
import shutil
from sklearn.cluster import MiniBatchKMeans
from skimage.color import rgb2lab, lab2rgb
import time

# Configuration
CACHE_DIR = os.path.expanduser("~/.config/bnsplit/cache/extractedColors")
OUTPUT_DIR = os.path.expanduser("~/.config/bnsplit/cache/extractedColors")
TARGET_SIZE = (200, 200)  # Reduced for speed
CLUSTER_BATCH_SIZE = 1024  # For MiniBatchKMeans


def get_image_hash(image_path):
    """Fast content-based hash using file metadata and initial bytes"""
    stat = os.stat(image_path)
    hasher = hashlib.sha256()
    hasher.update(f"{stat.st_size}-{stat.st_mtime}".encode())
    return hasher.hexdigest()[:16]


def process_image(image_path):
    """Optimized image processing pipeline"""
    img = Image.open(image_path)
    if img.format == "GIF":
        img.seek(0)

    # Fast resize and conversion
    img = img.convert("RGB").resize(TARGET_SIZE, Image.Resampling.LANCZOS)
    pixels = np.array(img, dtype=np.uint8).reshape(-1, 3)

    # Vectorized LAB conversion
    lab_pixels = rgb2lab(pixels[None, ...]).reshape(-1, 3)

    # Efficient clustering
    kmeans = MiniBatchKMeans(
        n_clusters=8, n_init=3, random_state=42, batch_size=CLUSTER_BATCH_SIZE
    )
    kmeans.fit(lab_pixels)

    # Get sorted colors by frequency
    counts = np.bincount(kmeans.labels_, minlength=8)
    sorted_colors = [
        lab2rgb(center[None, ...])[0] for center in kmeans.cluster_centers_
    ]
    sorted_colors = [np.clip(c * 255, 0, 255).astype(int) for c in sorted_colors]
    return [c.tolist() for _, c in sorted(zip(counts, sorted_colors), reverse=True)]


def generate_colors(image_path):
    """Main processing with cache support"""
    cache_key = get_image_hash(image_path)
    cache_dir = os.path.join(CACHE_DIR, cache_key)

    # Check cache
    if os.path.exists(cache_dir):
        return cache_dir

    # Process and cache
    start_time = time.time()
    colors = process_image(image_path)

    # Brightness swap
    if len(colors) >= 2:
        b1 = 0.299 * colors[0][0] + 0.587 * colors[0][1] + 0.114 * colors[0][2]
        b2 = 0.299 * colors[1][0] + 0.587 * colors[1][1] + 0.114 * colors[1][2]
        if b2 > b1:
            colors[0], colors[1] = colors[1], colors[0]

    # Save to cache
    os.makedirs(cache_dir, exist_ok=True)
    with open(os.path.join(cache_dir, "colors-hex"), "w") as f:
        f.write("\n".join(f"#{r:02x}{g:02x}{b:02x}" for r, g, b in colors))
    with open(os.path.join(cache_dir, "colors-rgb"), "w") as f:
        f.write("\n".join(f"{r}, {g}, {b}" for r, g, b in colors))

    print(f"Processed in {time.time()-start_time:.2f}s")
    return cache_dir


def main(image_path):
    try:
        # Ensure directories exist
        os.makedirs(OUTPUT_DIR, exist_ok=True)
        os.makedirs(CACHE_DIR, exist_ok=True)

        # Get or create cache
        cache_dir = generate_colors(image_path)

        # Copy to final location
        for fmt in ["hex", "rgb"]:
            src = os.path.join(cache_dir, f"colors-{fmt}")
            dst = os.path.join(OUTPUT_DIR, f"colors-{fmt}")
            shutil.copyfile(src, dst)

    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 col_gen.py /Path/To/Image")
        sys.exit(1)
    main(sys.argv[1])
