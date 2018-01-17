#!/bin/sh
set -e

export PORT=${PORT:-8000}
export REPO_URL=${REPO_URL:-http://autolandhg/}
export REPO_NAME=${REOP_NAME:-test-repo}

/create-config.py $AUTOLAND_HOME/autoland/config.json
/copy-template.py /httpd.conf.template /etc/apache2/httpd.conf
/copy-template.py /hgrc.template /hgrc

case "${1:-api}" in
    "init")
        echo Initialising Database
        $AUTOLAND_HOME/venv/bin/python /create-schema.py $AUTOLAND_HOME
        ;;
    "api")
        echo Starting autoland HTTPD on port $PORT
        exec httpd -DFOREGROUND
        ;;
    "daemon")
        # TODO echo Cloning test-repo from autolandhg
        # TODO hg clone http://autolandhg/ /repos/test-repo
        # TODO cp /hgrc /repos/test-repo/.hg
        cd $AUTOLAND_HOME
        . venv/bin/activate
        cd autoland
        exec python autoland.py
        ;;
    *)
        exec $*
        ;;
esac

