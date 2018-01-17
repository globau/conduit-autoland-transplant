#!/usr/bin/env python

import json
import sys

import psycopg2

if len(sys.argv) == 1:
    print('syntax: create-schema.py <autoland path>')
    sys.exit(1)
root = sys.argv[1]

with open('%s/autoland/config.json' % root) as f:
    config = json.load(f)

print('connecting to %s' % config['database'])
with psycopg2.connect(config['database']) as conn:
    conn.autocommit = True
    with conn.cursor() as curs:
        curs.execute(open('%s/sql/schema.sql' % root).read())
