# GitLab CI/CD Docker Images

This repository is where our Docker images for GitLab CI/CD usage are being crafted, along with some other stuff our infra team is doing here.
Please, read the README of the respective images before you use them on your own repos.

## What's we're currently maintaining

* [`mkdocs-material`](./docker/mkdocs-material/README.md) - Our own version of `squidfunk/mkdocs-material`, using latest version fo Python as possible.
  * To run the liveserver locally, run this command: `docker run --rm -it -p 8000:8000 -v ${PWD}:/docs madebythepinshub/mkdocs-material:liveserver liveserver`
  * WARNING: The `liveserver` tag is being deprecated and may be remove permanently from Docker Hub.

## Contributing

See the `CONTRIBUTTING.md` for details for contributing images for us or improving an existing one.

This repository adheres to [The Pins Team Community Code of Conduct][coc], based on [Contributor Convenant v2.0][contributor-convenant], and [the Developer's Certificate of Origin].

[coc]: https://github.com/MadeByThePinsHub/policies/blob/master/CODE_OF_CONDUCT.md
[contributor-convenant]: https://www.contributor-covenant.org/version/2/0/code_of_conduct/
