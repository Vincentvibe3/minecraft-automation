#!/bin/sh
if test "$eula" = "true" ; then
	sed -i 's/eula=false/eula=true/' eula.txt
fi
if test -n "$seed" ; then
	sed -i 's/level-seed=.*/level-seed=$seed/' server.properties
fi
if test -n "$rcon" ; then
	sed -i 's/enable-rcon=.*/enable-rcon=$rcon/' server.properties
fi
if test -n "$rconpwd" ; then
	sed -i 's/rcon.password=.*/rcon.password=$rconpwd/' server.properties
fi
if test -n "$gamemode" ; then
	sed -i 's/gamemode=.*/gamemode=$gamemode/' server.properties
fi
if test -n "$difficulty" ; then
	sed -i 's/difficulty=.*/difficulty=$difficulty/' server.properties
fi
if test -n "$whitelist" ; then
	sed -i 's/enforce-whitelist=.*/enforce-whitelist=$whitelist/' server.properties
	sed -i 's/white-list=.*/white-list=$whitelist/' server.properties
fi
if test -e ./libraries; then
	rm -r ./libraries
fi
cp -r ../libraries .
java -Xmx2G -jar ../server.jar nogui &
# from https://mbien.dev/blog/entry/stopping-containers-correctly
# Pass SIGTERM to the jvm to allow graceful shutdown
PID=$!
trap "kill -TERM $PID" INT TERM
wait $PID
trap - TERM INT
wait $PID
EXIT_STATUS=$?