#!/bin/sh

COMMAND_ARGS="$ALPINE_RELEASE"

if [ "$ALPINE_RELEASE" = "" ] && [ "$1" != "" ]; then
  echo "Please set the Alpine Linux release you want to use via ALPINE_RELEASE variable" && exit 1
fi

if [ "$COMMAND_ARGS" = "edge" ] || [ "$COMMAND_ARGS" = "" ]; then
  echo "Target release for image is edge, proceed at your own risk! Standing by in 5 seconds..." && wait 5
  printf "# Enable not only main and community, but also testing repo on edge\nhttp://dl-cdn.alpinelinux.org/alpine/edge/main\nhttp://dl-cdn.alpinelinux.org/alpine/edge/community\nhttp://dl-cdn.alpinelinux.org/alpine/edge/testing" > /etc/apk/repositories
else
  printf "# The testing repo only exists on edge, proceed at your own risk! \nhttp://dl-cdn.alpinelinux.org/alpine/%s/main\nhttp://dl-cdn.alpinelinux.org/alpine/%s/community\n" "$COMMAND_ARGS" "$COMMAND_ARGS" > /etc/apk/repositories
fi
