#!/bin/sh
set -e
REPO=${REOP:-test-repo}
/create-config.py $AUTOLAND_HOME/autoland/config.json

case "${1:-api}" in
    "init")
        echo Initialising Database
        $AUTOLAND_HOME/venv/bin/python /create-schema.py $AUTOLAND_HOME
        ;;
    "api")
        # TODO httpd listen port
        echo Starting autoland HTTPD
        exec httpd -DFOREGROUND
        ;;
    "daemon")
        cd $AUTOLAND_HOME
        . venv/bin/activate
        cd autoland
        exec python autoland.py
        ;;
    *)
        exec $*
        ;;
esac

