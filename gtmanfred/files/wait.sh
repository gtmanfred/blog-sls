#!/bin/bash
while ! pgrep dpkg 2>&1 >/dev/null;
    sleep 5
done
