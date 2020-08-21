#!/bin/bash -Eeu

readonly MY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export RUBYOPT='-W2 --jit'

puma \
  --port=${PORT} \
  --config=${MY_DIR}/puma.rb
