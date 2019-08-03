#!/bin/bash
set -e

readonly SH_DIR="$( cd "$( dirname "${0}" )" && pwd )"

${SH_DIR}/build_docker_images.sh
${SH_DIR}/docker_containers_up.sh

TMP_HTML_FILENAME=/tmp/avatars-demo.html

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

${SH_DIR}/docker_containers_down.sh
