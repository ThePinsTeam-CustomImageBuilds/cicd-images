FROM gitpod/workspace-full

# https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install Doppler CLI, Hadolint and ShellCheck
RUN curl -Ls --tlsv1.2 --proto "=https" --retry 3  https://cli.doppler.com/install.sh | sudo sh \
    && brew install hadolint shellcheck \
    # Needed for testing scripts in an Gitpod workspace while simulating GitLab CI env.
    && sudo install-packages gettext
