#!/bin/bash
set -e

readonly SH_DIR="$( cd "$( dirname "${0}" )" && pwd )"

${SH_DIR}/build_docker_images.sh
${SH_DIR}/docker_containers_up.sh

TMP_HTML_FILENAME=/tmp/avatars-demo.html

docker exec \
  test-avatars-client \
    sh -c 'ruby /app/src/html_demo.rb' \
      > ${TMP_HTML_FILENAME}

open "file://${TMP_HTML_FILENAME}"

${SH_DIR}/docker_containers_down.sh
