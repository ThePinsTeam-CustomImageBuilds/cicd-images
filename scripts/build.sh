#!/bin/bash

set -x

export CI_COMMIT_SHA=${CI_COMIT_SHA:-"$(git rev-parse HEAD)"}
SKIP_BUILD_STEP=${SKIP_BUILD_STEP:-"0"}

# TODO: Make this work on both CI and locally when invoked with an input
for directory in dirname $(git diff --name-only HEAD HEAD^); do
  if [[ $directory =~ docker\/.* ]] && [ -f "$PWD/$directory/build-metadata.json" ] && [ -f "$PWD/$directory/Dockerfile" ]; then
    echo "info: Building Docker image for $PWD/$directory..."
    CI_BUILD_TIME="$(date --iso-8601=seconds)" envsubst < "$PWD/$directory/build-metadata.json" > "$PWD/$directory/build-metadata.generated.json"

    echo "========== DEBUG: IMAGE METADATA FOR $directory =========="
    docker buildx bake --file /tmp/mkdocs-material-metadata.json --file "$PWD/$directory/build-metadata.generated.json" --push build --print
    echo
    sleep 5

    echo "========== BUILD STEP FOR $directory =========="
    if [[ $SKIP_BUILD_STEP == "0" ]]; then
      docker buildx bake --file "$PWD/$directory/build-metadata.generated.json" --push build
    else
      echo "warning: Buildkit Publish step is being skipped!"
      docker buildx bake --file "$PWD/$directory/build-metadata.generated.json"
    fi
    echo
  else
    echo "warning: Unsupported image path, please make sure $directory has either Dockerfile, build-metadata.json, or both. SKipping..."
    echo
  fi
done
