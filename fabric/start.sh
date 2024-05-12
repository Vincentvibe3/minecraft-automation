#!/bin/bash
cp -r --update=none /home/server/default/* .
if test "$eula" = "true" ; then
	sed -i "s/eula=false/eula=true/" eula.txt
fi
if test -n "$seed" ; then
	sed -i "s/level-seed=.*/level-seed=$seed/" server.properties
fi
if test -n "$rcon" ; then
	sed -i "s/enable-rcon=.*/enable-rcon=$rcon/" server.properties
fi
if test -n "$rconpwd" ; then
	sed -i "s/rcon.password=.*/rcon.password=$rconpwd/" server.properties
fi
if test -n "$gamemode" ; then
	sed -i "s/gamemode=.*/gamemode=$gamemode/" server.properties
fi
if test -n "$difficulty" ; then
	sed -i "s/difficulty=.*/difficulty=$difficulty/" server.properties
fi
if test -n "$whitelist" ; then
	sed -i "s/enforce-whitelist=.*/enforce-whitelist=$whitelist/" server.properties
	sed -i "s/white-list=.*/white-list=$whitelist/" server.properties
fi
if test -e ./versions; then
	rm -r ./versions
fi
cp -r /home/server/default/versions .
if test -e ./libraries; then
	rm -r ./libraries
fi
cp -r /home/server/default/libraries .

while true; do
	java "-Xms$memory" "-Xmx$memory" -XX:+UnlockExperimentalVMOptions -XX:+UseShenandoahGC -XX:ShenandoahGCMode=iu -XX:+AlwaysPreTouch -XX:+UseNUMA -XX:+DisableExplicitGC -jar ../server.jar nogui &
	# from https://mbien.dev/blog/entry/stopping-containers-correctly
	# Pass SIGTERM to the jvm to allow graceful shutdown
	PID=$!
	trap "kill -TERM $PID; break" INT TERM
	wait $PID
	EXIT_STATUS=$?
	if [[$EXIT_STATUS != 0]];then
		break;
	fi
	echo "Restarting server"
done
