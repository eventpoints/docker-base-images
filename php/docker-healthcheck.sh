#!/bin/sh
set -e

if env -i REQUEST_METHOD=GET SCRIPT_NAME=/ping SCRIPT_FILENAME=/ping \
    cgi-fcgi -bind -connect 127.0.0.1:9000 >/dev/null 2>&1; then
  exit 0
fi

exit 1
