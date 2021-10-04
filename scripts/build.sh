#!/bin/bash

set -ex

export CI_COMMIT_SHA=${CI_COMIT_SHA:-"$(git rev-parse HEAD)"}

# TODO: Do the actual Docker build with BuildKit soon.
for directory in dirname $(git diff --name-only HEAD HEAD^); do
  if [[ $directory =~ docker\/.* ]] && [ -f "$PWD/$directory/build-metadata.json" ] && [ -f "$PWD/$directory/Dockerfile" ]; then
    CI_BUILD_TIME="$(date --iso-8601=seconds)" envsubst < "$PWD/$directory/build-metadata.json" > "$PWD/$directory/build-metadata.generated.json"

    echo "========== DEBUG: IMAGE METADATA =========="
    docker buildx bake --file /tmp/mkdocs-material-metadata.json --file "$PWD/$directory/build-metadata.generated.json" --push build --print
    echo "========== DEBUG: IMAGE METADATA =========="
    sleep 5

    echo "info: Build step logs streams below..."
    docker buildx bake --file "$PWD/$directory/build-metadata.generated.json" --push build
  else
    echo "warning: Unsupported image path, please make sure $directory has either Dockerfile, build-metadata.json, or both."
  fi
done
