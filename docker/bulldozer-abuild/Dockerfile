ARG ALPINE_RELEASE=edge
FROM alpine:${ALPINE_RELEASE}

ARG ALPINE_RELEASE=edge
ENV ALPINE_RELEASE=${ALPINE_RELEASE:-"edge"}

# Imported from the upstream repos, check the README for those links.
COPY overlay/ /

# Upgrade verything and install tooling, but in this image, we'll install full GCC here.
RUN /usr/local/bin/change-repos.sh $ALPINE_RELEASE \
    && apk -U upgrade -a && apk add \
        alpine-sdk \
        abuild \
        atools \
        lua-aports \
        pigz \
        sudo \
        gcc \
        gcc-gnat \
        git \
        shellcheck
        spdx-licenses-list \
    && rm -rf /var/cache/apk/* \
    # use buildozer for building and linting
    && adduser -D buildozer \
    && adduser buildozer abuild \
    && adduser buildozer wheel \
    # default distfiles location
    && install -d -g abuild -m 775 /var/cache/distfiles \
    # fix permissions due to umask 0000
    && chmod 750 /etc/sudoers.d && chmod 640 /etc/sudoers.d/* && chmod 640 /etc/sudo.conf \

# TODO: Install the Docker CLI from either Alpine Linux's repos or from Docker

USER bulldozer

# Ensure sudo works before successfully, possibly swutch scripts to use doas instead in the future.
RUN sudo touch /etc/.sudo_successful_bulldozer
