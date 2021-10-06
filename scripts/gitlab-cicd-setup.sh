#!/bin/bash

# This script assumes that you're in an Alpine Linux-based distribution/container, as this script is being
# used in GitLab CI/CD.

set -exu

# We need to hardcode the defaults so we'll not get f**ked up by unused variable errors.
SKIP_DOPPLER_STEP=${SKIP_DOPPLER_STEP:-"0"}
SKIP_LOGIN_STEP=${SKIP_LOGIN_STEP:-"0"}
SKIP_BUILDKIT_SETUP=${SKIP_BUILDKIT_SETUP:-"0"}
HADOLINT_VERSION=${HADOLINT_VERSION:="2.7.0"}
BUILDX_VER=${BUILDX_VER:-"0.6.3"}

# If something is needed in other scripts through the lifecycle of this one, just export it.
export CI_REGISTRY=${CI_REGISTRY:-"registry.gitlab.com"} \
    CI_SERVER_HOST=${CI_SERVER_HOST:-"gitlab.com"} \
    CI_SERVER_PORT=${CI_SERVER_PORT:-"443"}

# Step 1: Install Doppler
if [ "$SKIP_DOPPLER_STEP" == "0" ]; then
  curl -Ls --tlsv1.2 --proto "=https" --retry 3 https://cli.doppler.com/install.sh | sh
else
  echo "warning: Doppler CLI install step is being skipped!"
fi

# Step 2: Install Hadolint and ShellCheck
echo "==> Installing ShellCheck and Hadolint"
apk add shellcheck
wget "https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64" -O /usr/local/bin/hadolint
chmod +x /usr/local/bin/hadolint

if [ "$SKIP_LOGIN_STEP" == "0" ]; then
  doppler run -- ./scripts/docker-login.sh
else
  echo "warning: Login step was being skipped!"
fi

# Step 3: Install Buildx plugin
mkdir -p "$HOME/.docker/cli-plugins"
wget -qO ~/.docker/cli-plugins/docker-buildx "https://github.com/docker/buildx/releases/download/v${BUILDX_VER}/buildx-v${BUILDX_VER}.linux-amd64"
chmod +x /root/.docker/cli-plugins/docker-buildx

# Step 4: Setup multiarch builds ahead of time.
if [[ $SKIP_BUILDKIT_SETUP == "0" ]]; then
  echo "==> Setting up QEMU..."
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
  echo "==> Setting up Docker buildx..."
  docker buildx create --name thepinsteam-glcicd-custom-image-builder --use --driver docker-container --buildkitd-flags --allow-insecure-entitlement security.insecure --allow-insecure-entitlement network.host
  docker buildx inspect --bootstrap --builder thepinsteam-glcicd-custom-image-builder
  docker buildx install
fi
