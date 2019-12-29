#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

#- - - - - - - - - - - - - - - - - - - - - - - -
build_images()
{
  echo
  docker-compose \
    --file "${ROOT_DIR}/docker-compose.yml" \
    build \
    --build-arg COMMIT_SHA="$(git_commit_sha)"

}

# - - - - - - - - - - - - - - - - - - - - - - - -
git_commit_sha()
{
  echo $(cd "${ROOT_DIR}" && git rev-parse HEAD)
}

#- - - - - - - - - - - - - - - - - - - - - - - -
build_images
