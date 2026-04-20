#!/bin/bash
i3 split v > /dev/null
zathura "$1" --page="$2" --log-level=error
