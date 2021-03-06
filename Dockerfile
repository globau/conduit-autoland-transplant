# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

FROM alpine:3.6

RUN addgroup -g 10001 app \
    && adduser -D -u 10001 -G app -g app app \
    && mkdir /app \
    && chown app:app /app

ENV HG_VERSION 4.4
ENV VCT_HOME /app/version-control-tools
ENV VCT_REV 54be16c722bf16984131f78332fd5ebd46718e49
ENV AUTOLAND_HOME ${VCT_HOME}/autoland

RUN apk update \
    && apk add --no-cache python2 ca-certificates curl gettext \
    && apk add --no-cache --virtual build-dependencies build-base python-dev py-pip gcc postgresql-dev libffi-dev \
    && apk add --no-cache apache2 apache2-mod-wsgi openssh-client postgresql-client libffi \
    && pip install --no-cache "mercurial>=$HG_VERSION,<$HG_VERSION.99" virtualenv \
    && mkdir /repos /run/apache2

COPY requirements.txt /
COPY httpd.conf.template /
COPY hgrc.template /
COPY entrypoint.sh /
COPY create-config.py /
COPY create-schema.py /
COPY version.json /app/version.json

RUN hg clone https://hg.mozilla.org/hgcustom/version-control-tools $VCT_HOME -r $VCT_REV \
    && virtualenv $AUTOLAND_HOME/venv \
    && $AUTOLAND_HOME/venv/bin/pip install -r /requirements.txt \
    && apk del build-dependencies \
    && chown -R app:app /app /repos /etc/apache2 /run/apache2 /var/log/apache2

USER app
ENTRYPOINT ["/entrypoint.sh"]
CMD []
