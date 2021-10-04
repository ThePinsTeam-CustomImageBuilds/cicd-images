#!/bin/bash

for directory in find ./docker -maxdepth 1 -type d; do
  if [ -f "$PWD/$directory/Dockerfile" ]; then

    echo "========== HADOLINT REPORT FOR $directory/Dockerfile =========="
    hadolint --verbose $directory/Dockerfile
    echo
    sleep 5

  else
    echo "warning: No Dockerfile has been found for $directory."
  fi
done