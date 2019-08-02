#!/bin/bash

RUBYOPT='-w' \
  rackup  \
    --env production  \
    --host 0.0.0.0    \
    --port 5027       \
    --server thin     \
    --warn            \
      config.ru
