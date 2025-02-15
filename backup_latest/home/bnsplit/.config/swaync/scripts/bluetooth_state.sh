#!/bin/sh
bluetoothctl show | grep -q "Powered: yes" && echo true || echo false
