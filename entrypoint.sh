#!/bin/bash

if [ "$1" == "api" ]; then
    echo Starting autoland HTTPD
    exec httpd -DFOREGROUND

elif [ "$1" == "daemon" ]; then
    if [ "$COMPOSED" == "true" ] && [ ! -e /repos/test-repo ]; then
        echo Cloning test-repo from autolandhg
        hg clone http://autolandhg/ /repos/test-repo
        cp /hgrc /repos/test-repo/.hg
    fi

    # XXX debugging
    #cd $AUTOLAND_HOME
    #. venv/bin/activate
    #cd autoland
    #exec python autoland.py
    /bin/s6-svscan /etc/s6

fi
