#!/bin/bash

readonly root_dir="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly my_name=avatars

# - - - - - - - - - - - - - - - - - - - - - - - - - -
run_tests()
{
  local -r coverage_root=/tmp/coverage
  local -r user="${1}"
  local -r test_dir="test_${2}"
  local -r container_name=test-${my_name}-${2}

  docker exec \
    --user "${user}" \
    --env COVERAGE_ROOT=${coverage_root} \
    "${container_name}" \
      sh -c "/app/test/util/run.sh ${@:3}"

  local -r status=$?

  # You can't [docker cp] from a tmpfs, so tar-piping coverage out.
  docker exec "${container_name}" \
    tar Ccf \
      "$(dirname "${coverage_root}")" \
      - "$(basename "${coverage_root}")" \
        | tar Cxf "${root_dir}/${test_dir}/" -

  echo "Coverage report copied to ${test_dir}/coverage/"
  cat "${root_dir}/${test_dir}/coverage/done.txt"
  return ${status}
}

# - - - - - - - - - - - - - - - - - - - - - - - - - -
echo
run_tests nobody server "${*}"
server_status=$?
if [ "${server_status}" = "0" ];  then
  echo '------------------------------------------------------'
  echo 'All passed'
  exit 0
else
  echo
  echo "test-${my_name}-server: status = ${server_status}"
  echo
  exit 3
fi
