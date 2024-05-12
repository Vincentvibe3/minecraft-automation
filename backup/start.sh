#!/bin/bash
FILENAME="$WORLD_NAME_$(date +%Y%m%d-%H%M%S).tar.gz"
cd /home/server/data
mcrcon save-all save-off
tar -cvzf "/home/server/backups/$FILENAME" ./world ./mods
mcrcon save-on
/home/env/bin/python3 /s3upload.py "/home/server/backups/$FILENAME"