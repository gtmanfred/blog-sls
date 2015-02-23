#!/bin/bash
while ! apt-get --simulate install nginx; do
    sleep 5
done
