FROM gitpod/workspace-full

# https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install Doppler CLI and Hadolint
RUN curl -Ls --tlsv1.2 --proto "=https" --retry 3  https://cli.doppler.com/install.sh | sh \
    && brew install hadolint
