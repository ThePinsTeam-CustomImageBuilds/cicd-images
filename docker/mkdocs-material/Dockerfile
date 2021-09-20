# Attempt to use latest Python version as possible.
FROM python:3-alpine3.14

# Copy the entrypoint script into /usr/local/bin
COPY ./entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Add Git, wget and crul, maybe needed by your scripts, upgrade stuff
# and then install mkdocs
RUN apk add git wget curl bash dumb-init --no-cache && rm -rfv /etc/apk/cache /var/cache/apk \
    && pip3 install --no-cache-dir --upgrade pip setuptools wheel \
    && pip3 install --no-cache-dir \
        'mkdocs' \
        'mkdocs-material' \
        'mkdocs-awesome-pages-plugin' \
        'mkdocs-git-revision-date-localized-plugin' \
        'mkdocs-minify-plugin' \
        'mkdocs-redirects' \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

# assume you mounted it when running, but optionally change it with --workdir
# in ypur  `docker run` command
WORKDIR /docs

# For documentation purposes only, see https://docs.docker.com/engine/reference/builder/#expose
EXPOSE 8080

ENTRYPOINT ["dumb-init", "/usr/local/bin/docker-entrypoint.sh"]
CMD ["build"]
