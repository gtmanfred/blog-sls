#!/bin/bash
while pgrep dpkg 2>&1 >/dev/null; do
    sleep 5
done
