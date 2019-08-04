#!/bin/bash
set -e

readonly TMP_HTML_FILENAME=/tmp/avatars-demo.html

ip_address()
{
  if [ -n "${DOCKER_MACHINE_NAME}" ]; then
    docker-machine ip ${DOCKER_MACHINE_NAME}
  else
    echo localhost
  fi
}

docker exec \
  test-avatars-client \
    sh -c "ruby /app/src/html_demo.rb $(ip_address)" \
      > ${TMP_HTML_FILENAME}

open "file://${TMP_HTML_FILENAME}"
