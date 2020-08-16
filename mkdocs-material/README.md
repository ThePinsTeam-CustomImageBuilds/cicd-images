# Mkdocs Material Docker images

## Usage

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
