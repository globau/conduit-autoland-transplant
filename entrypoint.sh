#!/bin/sh
set -e
REPO=${REOP:-test-repo}
case "${1:-api}" in
    "init")
        # TODO initialise database
        ;;
    "api")
        echo Starting autoland HTTPD
        exec httpd -DFOREGROUND
        # TODO httpd listen port
        ;;
    "daemon")
        /create-config.py $AUTOLAND_HOME/autoland/config.json
        cd $AUTOLAND_HOME
        . venv/bin/activate
        cd autoland
        exec python autoland.py
        ;;
    *)
        exec $*
        ;;
esac

