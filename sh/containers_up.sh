#!/bin/bash -Eeu

# - - - - - - - - - - - - - - - - - - - - - -
ip_address()
{
  if [ -n "${DOCKER_MACHINE_NAME}" ]; then
    docker-machine ip ${DOCKER_MACHINE_NAME}
  else
    echo localhost
  fi
}

readonly IP_ADDRESS=$(ip_address)

# - - - - - - - - - - - - - - - - - - - - - -
wait_briefly_until_ready()
{
  local -r name="${1}"
  local -r port="${2}"
  local -r max_tries=80
  echo -n "Waiting until ${name} is ready"
  for _ in $(seq ${max_tries})
  do
    echo -n '.'
    if ready ${port}; then
      echo 'OK'
      return
    else
      sleep 0.1
    fi
  done
  echo 'FAIL'
  echo "${name} not ready after ${max_tries} tries"
  if [ -f "$(ready_response_filename)" ]; then
    echo "$(ready_response)"
  fi
  docker logs ${name}
  exit 3
}

# - - - - - - - - - - - - - - - - - - -
ready()
{
  local -r port="${1}"
  local -r path=ready?
  local -r ready_cmd="\
    curl \
      --output $(ready_response_filename) \
      --silent \
      --fail \
      -X GET http://${IP_ADDRESS}:${port}/${path}"
  rm -f "$(ready_response_filename)"
  if ${ready_cmd} && [ "$(ready_response)" = '{"ready?":true}' ]; then
    true
  else
    false
  fi
}

# - - - - - - - - - - - - - - - - - - -
ready_response()
{
  cat "$(ready_response_filename)"
}

# - - - - - - - - - - - - - - - - - - -
ready_response_filename()
{
  echo /tmp/curl-avatars-ready-output
}

# - - - - - - - - - - - - - - - - - - -
strip_known_warning()
{
  local -r log="${1}"
  local -r known_warning="${2}"
  local stripped=$(printf "${log}" | grep --invert-match -E "${known_warning}")
  if [ "${log}" != "${stripped}" ]; then
    >&2 echo "SERVICE START-UP WARNING: ${known_warning}"
  else
    >&2 echo "DID _NOT_ FIND WARNING!!: ${known_warning}"
  fi
  echo "${stripped}"
}

# - - - - - - - - - - - - - - - - - - -
exit_unless_clean()
{
  local -r name="${1}"
  local log=$(docker logs "${name}" 2>&1)

  #local -r mismatched_indent_warning="application(.*): warning: mismatched indentations at 'rescue' with 'begin'"
  #log=$(strip_known_warning "${log}" "${mismatched_indent_warning}")

  local -r line_count=$(echo -n "${log}" | grep -c '^')
  echo -n "Checking ${name} started cleanly..."
  # 3 lines on Thin (Unicorn=6, Puma=6)
  #Thin web server (v1.7.2 codename Bachmanity)
  #Maximum connections set to 1024
  #Listening on 0.0.0.0:5027, CTRL+C to stop
  if [ "${line_count}" == '6' ]; then
    echo 'OK'
  else
    echo 'FAIL'
    echo_docker_log "${name}" "${log}"
    exit 3
  fi
}

# - - - - - - - - - - - - - - - - - - -
echo_docker_log()
{
  local -r name="${1}"
  local -r docker_log="${2}"
  echo "[docker logs ${name}]"
  echo "<docker_log>"
  echo "${docker_log}"
  echo "</docker_log>"
}

# - - - - - - - - - - - - - - - - - - -
container_up_ready_and_clean()
{
  local -r service_name="${1}"
  local -r container_name="test-${service_name}"
  local -r port="${2}"
  echo
  docker-compose \
    --file "${ROOT_DIR}/docker-compose.yml" \
    up \
    -d \
    --force-recreate \
      "${service_name}"
  wait_briefly_until_ready "${container_name}" "${port}"
  exit_unless_clean "${container_name}"
}

# - - - - - - - - - - - - - - - - - - -
containers_up()
{
  container_up_ready_and_clean avatars-server "${CYBER_DOJO_AVATARS_PORT}"
  container_up_ready_and_clean avatars-client "${CYBER_DOJO_AVATARS_CLIENT_PORT}"
}
