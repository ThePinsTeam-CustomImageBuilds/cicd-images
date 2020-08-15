# Attempt to use latest Python version as possible.
FROM python:3.8.5-slim-buster

# Update Debian packages first
RUN apt update && apt upgrade -y

# Install git and other needed deps
RUN apt install -y git wget curl bash openssh

# Remember to nuke cached APT lists and archives
RUN rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Then install Mkdocs and the theme with pip.
RUN pip3 install --no-cache mkdocs mkdocs-material

# ..and the basic plugins
RUN pip install --no-cache-dir \
        'mkdocs-awesome-pages-plugin' \
        'mkdocs-git-revision-date-localized-plugin' \
        'mkdocs-minify-plugin' \
        'mkdocs-redirects';
