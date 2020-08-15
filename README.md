# GitLab CI/CD Docker Images

This repository is where our Docker images for GitLab CI/CD usage are being crafted.

## What's we're currently maintaining

* `madebythepinshub/mkdocs-material` - Our own version of `squidfunk/mkdocs-material`, using latest version fo Python as possible.
  * To run the liveserver locally, pull the image with the `liveserver` tag. After pull, run the following command.
  ```bash
  docker run --rm -it -p 8000:8000 -v ${PWD}:/docs madebythepinshub/mkdocs-material:liveserver
  ```

## Contributing

See the `CONTRIBUTTING.md` for details.
