#!/bin/bash
set -e

if [ "${1}" = '-h' ] || [ "${1}" = '--help' ]; then
  echo
  echo 'Use: pipe_build_up_test.sh [HEX-ID...]'
  echo 'Options:'
  echo '   HEX-ID  - only run the tests matching this identifier'
  exit 0
fi

readonly SH_DIR="$( cd "$( dirname "${0}" )" && pwd )/sh"

${SH_DIR}/build_docker_images.sh "$@"
${SH_DIR}/docker_containers_up.sh "$@"
${SH_DIR}/run_tests_in_containers.sh "$@"
if [ "${AVATARS_COVERAGE}" != 'off' ]; then
  open file://${SH_DIR}/../test_server/coverage/index.html
fi
if [ "${AVATARS_DEMO}" != 'off' ]; then
  ${SH_DIR}/demo_html.sh
fi
${SH_DIR}/docker_containers_down.sh
