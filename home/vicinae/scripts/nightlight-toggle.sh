#!/usr/bin/env bash
# @vicinae.schemaVersion 1
# @vicinae.title Toggle Nightlight
# @vicinae.mode silent
# @vicinae.icon 💡
# @vicinae.exec ["/usr/bin/env", "bash"]

qs ipc call nightlight toggle
echo "Toggled Nightlight"
