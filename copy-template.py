#!/usr/bin/env python

# Trivial templating system.
# Replaces ${NAME} in the source with the NAMEd environmental variable.

import re
import os
import sys


def expand_env(match):
    return os.getenv(match.group(1), '')


if len(sys.argv) != 3:
    print('syntax: copy-template.py <source> <destination>')
    sys.exit(1)

with open(sys.argv[1]) as src:
    with open(sys.argv[2], 'w') as dst:
        dst.write(re.sub(r'\${([^}]+)}', expand_env, src.read()))
