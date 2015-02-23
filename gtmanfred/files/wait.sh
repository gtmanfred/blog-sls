#!/bin/bash
while true; do
    dpkg -i /dev/zero 2>&1 >/dev/null
    if [[ $? == 1 ]]; then
        exit 0
    fi
done
