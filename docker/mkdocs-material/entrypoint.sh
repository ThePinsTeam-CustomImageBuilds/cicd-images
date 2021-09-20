#!/bin/sh
# shellcheck shell=sh

if [ "$1" = "" ] || [ "$1" = "build" ]; then
  echo "info: Warmup starts in 5 seconds..." && wait 5
  if [ -f "$PWD/requirements.txt" ]; then
     if ! pip3 install -r "$PWD/requirements.txt" --upgrade; then
       EXIT_CODE=$?
       echo "error: Python package install went into chaos, aborting..." && exit $EXIT_CODE
     fi
  fi

  if [ "$MKDOCS_CONFIG_FILE" != "" ] && [ -f "$PWD/$MKDOCS_CONFIG_FILE" ]; then
     if ! mkdocs build --clean --dir "$PWD/public" --verbose --config-file "$PWD/$MKDOCS_CONFIG_FILE"; then
        ERROR_CODE=$?
        echo "error: build failed with code $ERROR_CODE, the build log above has more details" && exit "$ERROR_CODE"
     else
        echo "info: Build success, it's on ./public directory of your mounted directory" && exit 0
     fi
  else
    echo "warning: That config file you set on MKDOCS_CONFIG_FILE doesn't exist in current directory." && wait 5
  fi

  if [ -f "$PWD/mkdocs.yml" ]; then
     if ! mkdocs build --clean --dir "$PWD/public" --verbose; then
        ERROR_CODE=$?
        echo "error: build failed with code $ERROR_CODE, the build log above has more details" && exit "$ERROR_CODE"
     else
        echo "info: Build success, it's on ./public directory of your mounted directory" && exit 0
     fi
  else
    echo "error: no mkdocs.yml file found, aborting..." && exit 1
  fi
elif [ $1 = "live-preview" ] || [ $1 == "liveserver" ]; then
  echo "info: Wramup will start in 5 seconds..." && wait 5
  if [ -f "$PWD/requirements.txt" ]; then
     if ! pip3 install -r "$PWD/requirements.txt" --upgrade; then
       EXIT_CODE=$?
       echo "error: Python package install went into chaos, aborting..." && exit $EXIT_CODE
     fi
  fi
  
  if [ "$MKDOCS_CONFIG_FILE" != "" ] && [ -f "$PWD/$MKDOCS_CONFIG_FILE" ]; then
     exec mkdocs serve --dev-addr 0.0.0.0:8080 --verbose --config-file "$PWD/$MKDOCS_CONFIG_FILE"
  else
    echo "warning: That config file you set on MKDOCS_CONFIG_FILE doesn't exist in current directory." && wait 5
  fi
  
  if [ -f "$PWD/mkdocs.yml" ]; then
    exec mkdocs serve --dev-addr 0.0.0.0:8080 --verbose --config-file "$PWD/mkdocs.yml"
  else
    echo "error: no mkdocs.yml file found, aborting..." && exit 1
  fi
else
  exec "$@"
fi
