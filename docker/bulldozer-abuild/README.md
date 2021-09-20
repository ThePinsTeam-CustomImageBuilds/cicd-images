# Bulldozer Alpine Linux Package Builder for Docker

Sightly combined from Alpine Linux's [build base](https://gitlab.alpinelinux.org/alpine/infra/docker/build-base) and [APKBUILD lint tools](https://gitlab.alpinelinux.org/alpine/infra/docker/apkbuild-lint-tools) Docker iamges,
to include ShellCheck, abuild-tools and `changed-apkbuild` scripts for our own usage with some sprinkles from [the alpine-gitlab-ci image](https://gitlab.alpinelinux.org/alpine/infra/docker/alpine-gitlab-ci). When used in `docker run`, make sure to mount the contents
of [local copy of aports tree](https://gitlab.alpinelinux.org/alpine/aports).

This Docker image is suitable for building packages, possibly on per MR basis, if you maintain your custom APKBUILDS in an Git repository
like the official Aports tree.

> Note that you can use your own package repository for Alpine here, but the format should have atleast any of these to keep backwards-compartibility with
the official Alpine Linux packages: `main`, `community`, `testing` and `non-free`.

## Usage with GitLab CI

```yml
# Also try our ghcr.io, quay.io and docker.io mirrors if you prefer
# Remember to use GitLab Container Proxy if your org only want Docker Hub
image: registry.gitlab.com/madebythepinshub/infra/docker/custom-cicd-images/bulldozer-abuilds

services:
  - name: docker:dind
    alias: "docker" # Just in case you're using other Dind images other that the official ones


variables:
  # Assuming that your GitLab repo is your APKBUILD sources Git repo. When this is unset, it will rely on
  # the value of CI_PROJECT_DIR for GitLab users. For users who use other CI/CD service such as GitHub Actions,
  # this may complicate things as we need to mount stuff, adjust permissions, and even fake GitLab CI environment.
  # Consult the GitLab Docs at https://docs.gitlab.com/ee/ci/variables/predefined_variables.html on what variables
  # you need to fake and also check with your CI service's predefined variables too.
  BULLDOZER_SRC_DIR: $CI_PROJECT_DIR
  # For multiarch APK builds, your GitLab runner if you ever self-host runners, requires to be an Docker executor.
  # See https://docs.gitlab.com/ee/ci/docker/using_docker_build.html#use-the-docker-executor-with-the-docker-image-docker-in-docker
  # for details. Remember to use TLS as possible, see https://docs.gitlab.com/ee/ci/docker/using_docker_build.html#tls-enabled.
  DOCKER_HOST: tcp://docker:2376
  # Needed to mount our stuff for multiarch builds
  MOUNT_POINT: $CI_PROJECT_DIR/mnt

stage:
  - build
  - lint

before_script:
  - mkdir -p "$MOUNT_POINT"
  # Uncomment if you mirror Alpine Linux package repos through building from source, following the
  # Reproducible Builds principle. This GitLab CI will only clone the repo with only the master branch, which
  # corresponds to the edge version/release. 
  #- git clone --branch "master" https://gitlab.alpinelinux.org/alpune/aports $MOUNT_POINT/aports
  # If you also maintain an fork of aports tree, you probably want to also do that too, but please do an regular
  # MR instead.

# While you can use the image itself to lint and build Alpine Linux packages in same arch as the runner,
# (in case of GitLab SaaS) we recommend setting up an Docker-in-Docker setup and use 'docker run' or
# prepare an multiarch-ready self-hosted runner instead to match the expected behavior on what Alpine
# packaging team has been doing. For publishing new builds into your own package repository, you may consider
# checking out https://gitlab.alpinelinux.org/alpine/infra/docker/aports-build instead.
```

## Image URLs and Tags

This Docker image is available at the following registries:

* GitLab Container Registry, hosted on GitLab SaaS: `registry.gitlab.com/madebythepinshub/infra/docker/custom-cicd-images/bulldozer-abuilds`
* GHCR for GitHub users: `ghcr.io/thepinsteam-customimagebuilds/bulldozer-abuild`
* RHQCR and Docker Hub: Use `madebythepinshub` as the namespace and `bulldozer-abuild` for the image repository. To use RHQCR, prefix `quay.io/`
before our namespace.

### Image Tags

We're building this image against the latest edge builds for Alpine Linux on both `latest` and `edge` tags, so be prepared or instabilities.
For stable versions, we only maintain atleast seperate 2 image tags corresponding to the last 2 stable versions (stable + oldstable) only in
an foreseekable future.
