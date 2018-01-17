#!/usr/bin/env python

import json
import os
import sys

if len(sys.argv) != 2:
    print('syntax: create-config.py <config filename>')
    sys.exit(1)

config = dict(testing=True, auth={}, database="", repos={}, pingback={},
              patch_url_buckets={})

config['database'] = "host='%s' dbname='%s' user='%s' password='%s'" % (
    os.getenv('DATABASE_HOST', 'autolanddb'),
    os.getenv('DATABASE_NAME', 'autoland'),
    os.getenv('DATABASE_USER', 'autoland'),
    os.getenv('DATABASE_PASS', 'autoland'))

config['auth']['autoland'] = os.getenv('AUTOLAND_KEY', 'autoland')

config['repos'][os.getenv('REPO_NAME', 'test-repo')] = {
    "tree": os.getenv('REPO_TREE', 'test'),
}

config['pingback'][os.getenv('LANDO_HOST', 'lando.example.com')] = {
    "type": "lando",
    "api-key": os.getenv('LANDO_API_KEY', 'secret'),
}

config['patch_url_buckets'][os.getenv('LANDO_BUCKET', 'lando-dev')] = {
    "aws_access_key_id": os.getenv('LANDO_AWS_KEY', 'key'),
    "aws_secret_access_key": os.getenv('LANDO_AWS_SECRET', 'secret'),
}

with open(sys.argv[1], mode='w') as f:
    json.dump(config, f, indent=4, sort_keys=True)
