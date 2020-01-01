#!/bin/bash -Ee

readonly SH_DIR="$( cd "$( dirname "${0}" )/sh" && pwd )"

if [ "${1}" == '-h' ] || [ "${1}" == '--help' ]; then
  echo
  echo 'Use: pipe_build_up_test.sh [HEX-ID...]'
  echo 'Options:'
  echo '   HEX-ID  - only run the tests matching this identifier'
  exit 0
fi


source ${SH_DIR}/versioner_env_vars.sh
export $(versioner_env_vars)
${SH_DIR}/build_images.sh "$@"
${SH_DIR}/containers_up.sh "$@"
${SH_DIR}/test_in_containers.sh "$@"
${SH_DIR}/containers_down.sh
${SH_DIR}/tag_image.sh
${SH_DIR}/on_ci_publish_tagged_images.sh
# open file://${SH_DIR}/../test_server/coverage/index.html
