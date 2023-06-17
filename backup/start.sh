#!/bin/sh
if test "$1" = "backup" ; then
	cd /home/data
	tar -cvzf /home/backups/$2_$3_$(date +%Y%m%d-%H%M%S).tar.gz .
fi
if test "$1" = "restore" ; then
	tar -xvzf /home/backups/backup.tar.gz --directory /home/data 
fi