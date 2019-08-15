#!/bin/bash

if [ "${1}" = '-h' ] || [ "${1}" = '--help' ]; then
  echo
  echo 'Use: pipe_build_up_test.sh [HEX-ID...]'
  echo 'Options:'
  echo '   HEX-ID  - only run the tests matching this identifier'
  exit 0
fi

readonly SH_DIR="$( cd "$( dirname "${0}" )" && pwd )/sh"

if ! ${SH_DIR}/build_docker_images.sh "$@" ; then
  exit 3
fi

if ! ${SH_DIR}/docker_containers_up.sh "$@" ; then
  exit 3
fi

if ${SH_DIR}/run_tests_in_containers.sh "$@" ; then
  ${SH_DIR}/docker_containers_down.sh
else
  if [ "${AVATARS_COVERAGE}" != 'off' ] ; then
    open file://${SH_DIR}/../test_server/coverage/index.html
  fi
  if [ "${AVATARS_DEMO}" != 'off' ] ; then
    ${SH_DIR}/demo_html.sh
  fi
fi
