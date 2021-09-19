# Mkdocs + Material theme Docker image

An Python 3.x Alpine Docker image, with Material for Mkdocs theme and some plugins that support that theme packaged for you.

## Usage in GitLab

```yml
# If your project is completely Python3 project, uncomment the line below.
#image: registry.gitlab.com/madebythepinshub/infra/docker/custom-cicd-images/mkdocs-material

pages:
  image: registry.gitlab.com/madebythepinshub/infra/docker/custom-cicd-images/mkdocs-material
  before_script:
    - pip3 install -r docs/requirements.txt
  script:
    - mkdocs build && mv docs/public ./public
  artifacts:
    paths:
      - public
```

## As `docker run` command

```sh
# Build your docs, as usual. Remember that the entrypoint script will install the dependencies for you if
# requirements.txt is found. We'll work on supporting other formats.
# Please be reminded that we only support the latest Python version, so you may need to build your own
# image based on this one if that's your use case.
# No need to append the build command for the entrypoint script since it'll install packages and build
# it for you.
docker run --rm -it -v "$PWD/docs":/docs registry.gitlab.com/madebythepinshub/infra/docker/custom-cicd-images/mkdocs-material

# Preview your docs as you edit
docker run --rm -it -v "$PWD/docs":/docs -p 8080:8080 registry.gitlab.com/madebythepinshub/infra/docker/custom-cicd-images/mkdocs-material liveserver
```

## Image URLs and Tags

This Docker image is available at the following registries:

* GitLab Container Registry, hosted on GitLab SaaS: `registry.gitlab.com/madebythepinshub/infra/docker/custom-cicd-images/mkdocs-material`
* GHCR for GitHub users: `ghcr.io/thepinsteam-customimagebuilds/mkdocs-material`
* RHQCR and Docker Hub: Use `madebythepinshub` as the namespace and `mkdocs-material` for the image repository. To use RHQCR, prefix `quay.io/`
before our namespace.
