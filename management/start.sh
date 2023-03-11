#!/bin/sh
$OPENVSCODE_SERVER_ROOT/bin/openvscode-server --host 0.0.0.0 --without-connection-token \"${@}\" &
# from https://mbien.dev/blog/entry/stopping-containers-correctly
# Pass SIGTERM to the jvm to allow graceful shutdown
PID=$!
trap "kill -TERM $PID" INT TERM
wait $PID
trap - TERM INT
wait $PID
EXIT_STATUS=$?