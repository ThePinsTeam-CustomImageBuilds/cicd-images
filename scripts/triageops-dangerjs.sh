#!/bin/bash

set -ex

if [[ $CI == "true" ]]; then
  # Use Doppler as possible.
  doppler run --command="yarn ci:dangerjs"
else
  echo 'error: No support for local Dangerfile yet. *sad Lienus noises*'
  exit 1
fi
