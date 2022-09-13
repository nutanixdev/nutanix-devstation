# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.241.1/containers/python-3/.devcontainer/base.Dockerfile

# [Choice] Python version (use -bullseye variants on local arm64/Apple Silicon): 3, 3.10, 3.9, 3.8, 3.7, 3.6, 3-bullseye, 3.10-bullseye, 3.9-bullseye, 3.8-bullseye, 3.7-bullseye, 3.6-bullseye, 3-buster, 3.10-buster, 3.9-buster, 3.8-buster, 3.7-buster, 3.6-buster
ARG VARIANT="3.10-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/python:0-${VARIANT}

# Options
ARG ENABLE_NONROOT_DOCKER="false"
ARG USE_MOBY="false"
ARG DOCKER_VERSION="none"
ARG USERNAME=vscode
ARG NODE_VERSION="none"
ARG ANSIBLE_VERSION="none"
ARG PACKER_VERSION="none"
ARG KUBECTL_KARBON="false"
ARG OPENSHIFT_CLI_VERSION="none"
ARG CLUSTERCTL_VERSION="none"
ARG CALM_DSL_VERSION="none"

# Enable new "BUILDKIT" mode for Docker CLI
ENV DOCKER_BUILDKIT=1

COPY library-scripts/*.sh /tmp/library-scripts/

RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/home/$USERNAME/.nutanixdev/.bash_history" \
    && mkdir /home/$USERNAME/.nutanixdev \
    && touch /home/$USERNAME/.nutanixdev/.bash_history \
    && chown -R $USERNAME /home/$USERNAME/.nutanixdev \
    && echo "$SNIPPET" >> "/home/$USERNAME/.bashrc"

# Install docker-in-docker
RUN if [ "${USE_MOBY}" != "false" ]; then \
        bash /tmp/library-scripts/docker-in-docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "${USERNAME}" "${USE_MOBY}" "${DOCKER_VERSION}"; \
    fi

# Install node.js
RUN if [ "${NODE_VERSION}" != "none" ]; then \
        su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; \
    fi

# Install Ansible
RUN if [ "${ANSIBLE_VERSION}" != "none" ]; then \
        pip3 --disable-pip-version-check --no-cache-dir install ansible==${ANSIBLE_VERSION}; \
    fi

# Install Packer
RUN if [ "${PACKER_VERSION}" != "none" ]; then \
        bash /tmp/library-scripts/packer-debian.sh "${PACKER_VERSION}"; \
    fi

# Install kubectl karbon
RUN if [ "${KUBECTL_KARBON}" != "false" ]; then \
        su vscode -c "umask 0002 && . /tmp/library-scripts/kubectlkarbon-linux.sh"; \
    fi

# Install OpenShift CLI
RUN if [ "${OPENSHIFT_CLI_VERSION}" != "none" ]; then \
        bash /tmp/library-scripts/openshiftcli-linux.sh "${OPENSHIFT_CLI_VERSION}"; \
    fi 

# Install Clusterctl CLI
RUN if [ "${CLUSTERCTL_VERSION}" != "none" ]; then \
        bash /tmp/library-scripts/clusterctl-linux.sh "${CLUSTERCTL_VERSION}"; \
    fi 

# Install Calm DSL
RUN if [ "${CALM_DSL_VERSION}" != "none" ]; then \
        bash /tmp/library-scripts/calmdsl-debian.sh "${CALM_DSL_VERSION}" \
        && mkdir /home/$USERNAME/.calm \
        && chown -R $USERNAME /home/$USERNAME/.calm; \
    fi \
    && rm -rf /tmp/library-scripts

VOLUME [ "/var/lib/docker" ]

# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
# COPY requirements.txt /tmp/pip-tmp/
# RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp

# Setting the ENTRYPOINT to docker-init.sh will start up the Docker Engine 
# inside the container "overrideCommand": false is set in devcontainer.json. 
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

