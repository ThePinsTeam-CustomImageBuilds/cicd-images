#!/bin/bash

# The good ol' GitHub Container Registry
if [ "$GH_SERVICE_ACCOUNT_API_KEY" != "" ]; then
  docker login ghcr.io --username RecapTimeBot --password "$GH_SERVICE_ACCOUNT_API_KEY"
else
  echo "warning: No PAT for GitHub Container Registry, skipping..."
fi

# GitLab Container Registry on GitLab SaaS
if [[ $GITLAB_CONTAINER_REGISTRY_PASSWORD != "" ]] && [[ $GITLAB_CONTAINER_REGISTRY_USERNAME != "" ]]; then
  docker login "$CI_REGISTRY" --username "$GITLAB_CONTAINER_REGISTRY_USERNAME" --password "$GITLAB_CONTAINER_REGISTRY_PASSWORD"
  docker login "$CI_SERVER_HOST:$CI_SERVER_PORT" --username "$GITLAB_CONTAINER_REGISTRY_USERNAME" --password "$GITLAB_CONTAINER_REGISTRY_PASSWORD"
else
  echo "warning: No GitLab Deploy Token to use for Dependency Proxy, skipping..."
fi

# Red Hat Quay Container Registry, or simply put Quay.io
if [[ $RHQCR_SERVICE_ACCOUNT_USERNAME != "" ]] && [[ $RHQCR_SERVICE_ACCOUNT_API_KEY != "" ]]; then
  docker login quay.io --username "$GITLAB_CONTAINER_REGISTRY_USERNAME" --password "$GITLAB_CONTAINER_REGISTRY_PASSWORD"
else
  echo "warning: No robot account to authenticate against quay.io, skipping..."
fi

# Finally Docker Hub
if [[ $DOCKERHUB_PASSWORD != "" ]] && [[ $DOCKERHUB_USERNAME != "" ]]; then
  docker login --username "$DOCKERHUB_USERNAME" --password "$DOCKERHUB_PASSWORD"
else
  echo "warning: No GitLab Deploy Token to use for Dependency Proxy, skipping..."
fi