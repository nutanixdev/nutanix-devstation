# [Choice] Python version (use -bullseye variants on local arm64/Apple Silicon): 3, 3.10, 3.9, 3.8, 3.7, 3.6, 3-bullseye, 3.10-bullseye, 3.9-bullseye, 3.8-bullseye, 3.7-bullseye, 3.6-bullseye, 3-buster, 3.10-buster, 3.9-buster, 3.8-buster, 3.7-buster, 3.6-buster
ARG VARIANT="3.11-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/python:0-${VARIANT}

ENV PYTHONUNBUFFERED 1

# Options
ARG USERNAME=vscode
ARG OPENSHIFT_CLI_VERSION="none"
ARG OPENSHIFT_INSTALL_VERSION="none"
ARG ANSIBLE_VERSION="none"
ARG PACKER_VERSION="none"
ARG CLUSTERCTL_VERSION="none"
ARG K9S_VERSION="none"
ARG KUBECTL_KARBON="false"
ARG NUTANIX_V4_SDK="false"
ARG CALM_DSL_VERSION="none"
ARG COOKIECUTTER_VERSION="none"


COPY library-scripts/*.sh /tmp/library-scripts/

# Persist bash/zsh history - https://code.visualstudio.com/remote/advancedcontainers/persist-bash-history
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/home/$USERNAME/.nutanixdev/.bash_history" \
    && mkdir /home/$USERNAME/.nutanixdev \
    && touch /home/$USERNAME/.nutanixdev/.bash_history \
    && chown -R $USERNAME /home/$USERNAME/.nutanixdev \
    && echo "$SNIPPET" | tee -a /home/$USERNAME/.bashrc /home/$USERNAME/.zshrc

# Install OpenShift CLI
RUN if [ "${OPENSHIFT_CLI_VERSION}" != "none" ]; then \
        bash /tmp/library-scripts/openshiftcli-linux.sh "${OPENSHIFT_CLI_VERSION}"; \
    fi

# Install OpenShift Install CLI
RUN if [ "${OPENSHIFT_INSTALL_VERSION}" != "none" ]; then \
        bash /tmp/library-scripts/openshift-install-linux.sh "${OPENSHIFT_INSTALL_VERSION}"; \
    fi

# Install Ansible
RUN if [ "${ANSIBLE_VERSION}" != "none" ]; then \
        pip3 --disable-pip-version-check --no-cache-dir install ansible==${ANSIBLE_VERSION} \
        && su vscode -c "ansible-galaxy collection install nutanix.ncp"; \
    fi

# Install Packer
RUN if [ "${PACKER_VERSION}" != "none" ]; then \
        bash /tmp/library-scripts/packer-debian.sh "${PACKER_VERSION}"; \
    fi

# Install Clusterctl CLI
RUN if [ "${CLUSTERCTL_VERSION}" != "none" ]; then \
        bash /tmp/library-scripts/clusterctl-linux.sh "${CLUSTERCTL_VERSION}"; \
    fi

# Install k9s CLI
RUN if [ "${K9S_VERSION}" != "none" ]; then \
        bash /tmp/library-scripts/k9s-linux.sh "${K9S_VERSION}"; \
    fi

# Install kubectl karbon
RUN if [ "${KUBECTL_KARBON}" != "false" ]; then \
        su vscode -c "umask 0002 && . /tmp/library-scripts/kubectlkarbon-linux.sh"; \
    fi

# Install Calm DSL
RUN if [ "${CALM_DSL_VERSION}" != "none" ]; then \
        bash /tmp/library-scripts/calmdsl-debian.sh "${CALM_DSL_VERSION}" \
        && mkdir /home/$USERNAME/.calm \
        && chown -R $USERNAME /home/$USERNAME/.calm; \
    fi \
    && rm -rf /tmp/library-scripts

# Install Cookiecutter
RUN if [ "${COOKIECUTTER_VERSION}" != "none" ]; then \
        pip3 --disable-pip-version-check --no-cache-dir install cookiecutter==${COOKIECUTTER_VERSION}; \
    fi

# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
# COPY requirements.txt /tmp/pip-tmp/
# RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# Copy all requirement files
COPY requirements/*.txt /tmp/pip-tmp/

# Install Nutanix v4 SDKs
RUN if [ "${NUTANIX_V4_SDK}" != "false" ]; then \
        pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements_nutanix_v4_sdk.txt; \
    fi

# Delete all requirement files in tmp
RUN rm -rf /tmp/pip-tmp

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

