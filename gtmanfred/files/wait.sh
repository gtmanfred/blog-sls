#!/bin/bash
while ! dpkg -i /dev/zero 2>&1 >/dev/null; do
    if [[ $? == 1 ]]; then
        break
    fi
done
