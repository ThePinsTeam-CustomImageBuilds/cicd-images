# Mkdocs Material Docker images

## Usage

### With GitLab CI/CD

```yml
# use this example on your .gitlab-ci.yml file
# no virtualenv usage required

pages:
  image: madebythepinshub/mkdocs-material
  script:
    - pip3 install --upgrade -r requirements.txt
    - mkdocs build
    - mv site public
  artifacts:
    paths:
      - public
```

## Support

* [Developers' Lounge on TG](https://t.me/ThePinsTeam_DevOpsChat)
* [Issue Tracker](https://github.com/ThePinsTeam-CustomImageBuilds/gitlab-cicd/issues)
