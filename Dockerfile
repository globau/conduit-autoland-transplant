# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

FROM alpine:3.6

ENV HG_RELEASE=4.4.1
ENV VCT_HOME /home/autoland/version-control-tools
ENV AUTOLAND_HOME /home/autoland/version-control-tools/autoland

# dependencies
RUN apk update; \
    apk add --no-cache python2 ca-certificates curl bash; \
    apk add --no-cache --virtual build-dependencies build-base python-dev py-pip gcc postgresql-dev libffi-dev; \
    apk add --no-cache apache2 apache2-mod-wsgi openssh-client postgresql-client libffi; \
    pip install --no-cache mercurial==$HG_RELEASE virtualenv


# user/group
RUN addgroup -g 1000 autoland; \
    adduser -D -u 1000 -G autoland -s /bin/bash autoland

# clone vct and setup venv
COPY requirements.txt /requirements.txt
RUN hg clone https://hg.mozilla.org/hgcustom/version-control-tools $VCT_HOME; \
    virtualenv $AUTOLAND_HOME/venv; \
    $AUTOLAND_HOME/venv/bin/pip install -r /requirements.txt

# httpd
RUN mkdir /run/apache2
COPY httpd.conf /etc/apache2/conf.d/autoland.conf

# autoland
COPY config.json $AUTOLAND_HOME/autoland/config.json

# hg
COPY hgrc /hgrc

RUN apk del build-dependencies

# XXX debugging
RUN apk add --no-cache s6
COPY ./etc /etc
# XXX

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
