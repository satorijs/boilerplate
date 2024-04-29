#!/usr/bin/env sh
set -eu

chown -R root:root /satori
if [ ! -e "/satori/package.json" ]; then
  unzip -d /satori /boilerplate.zip
  sed -Ei 's/(([[:space:]]*)maxPort.*)/\1\n\2host: 0.0.0.0/' /satori/cordis.yml
fi

exec "$@"
