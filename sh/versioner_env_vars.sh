#!/bin/bash -Eeu

versioner_env_vars()
{
  docker run --rm cyberdojo/versioner:latest
  echo CYBER_DOJO_AVATARS_CLIENT_PORT=9999
  echo CYBER_DOJO_AVATARS_CLIENT_USER=nobody
  echo CYBER_DOJO_AVATARS_SERVER_USER=nobody
}
