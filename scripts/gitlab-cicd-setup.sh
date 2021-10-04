#!/bin/bash

# This script assumes that you're in an Alpine Linux-based distribution/container, as this script is being
# used in GitLab CI/CD.

set -exu

# We need to hardcode the defaults so we'll not get f**ked up by unused variable errors.
DOCKERVERSION=${DOCKERVERSION:-"20.10.8"} # Match version to what gitpod/workspace-full uses
SKIP_DOPPLER_STEP=${SKIP_DOPPLER_STEP:-"0"}
SKIP_LOGIN_STEP=${SKIP_LOGIN_STEP:-"0"}
HADOLINT_VERSION=${HADOLINT_VERSION:="2.7.0"}

# If something is needed in other scripts through the lifecycle of this one, just export it.
export CI_REGISTRY=${CI_REGISTRY:-"registry.gitlab.com"} \
    CI_SERVER_HOST=${CI_SERVER_HOST:-"gitlab.com"} \
    CI_SERVER_PORT=${CI_SERVER_PORT:-"443"}

# Step 1: Download Docker CLI from upstream
curl -fsSLO "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz"
tar xzvf "docker-${DOCKERVERSION}.tgz" --strip 1 -C /usr/local/bin docker/docker
rm "docker-${DOCKERVERSION}.tgz"

# Step 2: Install Doppler
[ "$SKIP_DOPPLER_STEP" == "0" ] && curl -Ls --tlsv1.2 --proto "=https" --retry 3 https://cli.doppler.com/install.sh | sh

# Step 3: Install Hadolint and ShellCheck
apk add shellcheck
wget "https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64" -O /usr/local/bin/hadolint
chmod +x /usr/local/bin/hadolint

if [ "$SKIP_LOGIN_STEP" == "0" ]; then
  doppler run -- ./scripts/docker-login.sh
else
  echo "warning: Login step was being skipped!"
fi

# Step 4: Setup multiarch builds
docker buildx create --name thepinsteam-glcicd-custom-image-builder --use