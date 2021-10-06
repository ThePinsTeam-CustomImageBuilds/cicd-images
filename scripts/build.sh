#!/bin/bash

set -x

export CI_COMMIT_SHA=${CI_COMIT_SHA:-"$(git rev-parse HEAD)"}
SKIP_PUBLISH_STEP=${SKIP_PUBLISH_STEP:-"0"}
directory="docker/$1"

if [[ "$CI_IMAGE_TAG_NAME" == "" ]]; then
  echo "info: generating an temporary image tag because CI_IMAGE_TAG_NAME is undefined"
  if [[ "$(which openssl)" == "" ]]; then
    echo "warning: openssl isn't on your path, generating image tag from base64'd date"
    CI_IMAGE_TAG_NAME="build-$(date +%s | sha256sum | base64 | head -c 32 ; echo)"
  else
    CI_IMAGE_TAG_NAME="build-$(openssl rand -hex 32)"; export CI_IMAGE_TAG_NAME
  fi
elif [[ "$CI_COMMIT_BRANCH" == "main" ]]; then
  echo "info: using latest tag since CI_COMMIT_BRANCH is on main"
  export CI_IMAGE_TAG_NAME="latest"
fi

if [[ "$1" != "" ]] && [ -f "$PWD/docker/$1/build-metadata.json" ] && [ -f "$PWD/$directory/Dockerfile" ]; then
  echo "info: Building Docker image for $PWD/$directory..."
  CI_BUILD_TIME="$(date --iso-8601=seconds)" envsubst < "$PWD/$directory/build-metadata.json" > "$PWD/$directory/build-metadata.generated.json"

  echo "========== DEBUG: IMAGE METADATA FOR $directory =========="
  docker buildx bake --file "$PWD/$directory/build-metadata.generated.json" build --print
  echo
  sleep 5

  echo "========== BUILD STEP FOR $directory =========="
  if [[ $SKIP_PUBLISH_STEP == "0" ]]; then
    docker buildx bake --file "$PWD/$directory/build-metadata.generated.json" --push build
  else
    echo "warning: Buildkit Publish step is being skipped!"
    docker buildx bake --file "$PWD/$directory/build-metadata.generated.json" build
  fi
  echo
elif [[ "$1" != "" ]] && [ ! -f "$PWD/docker/$1/build-metadata.json" ] && [ -f "$PWD/$directory/Dockerfile" ]; then
  echo "error: No build-metadata.json file was found, failing build with error..."
  exit 1
fi
