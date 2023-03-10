#!/bin/sh
if test "$eula" = "true" ; then
	sed -i 's/eula=false/eula=true/' eula.txt
fi
rm -r ./versions
cp -r ../versions ./versions
rm -r ./libraries
cp -r ../libraries ./libraries
java -Xmx2G -jar ../server.jar nogui &
# from https://mbien.dev/blog/entry/stopping-containers-correctly
# Pass SIGTERM to the jvm to allow graceful shutdown
PID=$!
trap "kill -TERM $PID" INT TERM
wait $PID
trap - TERM INT
wait $PID
EXIT_STATUS=$?