# Nutanix Devstation

A toolkit container for automating Nutanix and its applications, deploying Kubernetes, and operating the platform at scale.

## Features

- Cross-platform: Windows and Mac (Intel or Apple silicon) are validated.
- Works with Docker Desktop and Rancher Desktop (dockerd - moby).

## Tools included

### CLIs

- [x] Python v3.11.x
- [x] Calm DSL v3.5.2
- [x] Ansible v2.14.1 (pip v7.1.0)
- [x] Terraform v1.3.7
- [x] PowerShell v7.3.1
- [x] Packer v1.8.5
- [x] Kubectl v1.26.0
- [x] Helm v3.10.3
- [x] minikube v1.28.0
- [x] Kubectl-karbon v0.9.4
- [x] OpenShift CLI (oc) v4.11.22
- [x] OpenShift Install CLI v4.11.22
- [x] Clusterctl v1.3.2
- [x] k9s v0.26.7
- [x] Cookiecutter v2.1.1
- [ ] Nutanix CLI (nCLI)
- [ ] Acropolis CLI (aCLI)

### VS Code Extensions

- Docker
- HashiCorp Terraform
- JSON Path Status Bar
- Kubernetes
- REST Client 
- YAML

## Requirements

- [Visual Studio Code](https://code.visualstudio.com/download)
- [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## How it works

The Nutanix Devstation doesn't ship a container image, instead it builds a local image in your computer based on the settings in the `devcontainer.json` file included in the `.devcontainer` directory.

When opening a project in VS Code that includes the `.devcontainer` directory, the Dev Container extension prompts the option for building the container. Then the project folder is mounted inside the container. The content of the project folder is always available regardless of opening it locally or in the container.

Additionally, two container volumes are used for persisting Calm DSL cache and bash history after rebuilding the container when making changes to `devcontainer.json`.

## How to use

You only need the `.devcontainer` directory in the project root folder:

1. Clone or download the repository.

1. Copy or move the `.devcontainer` directory to your project.

1. To enable/disable or configure different tool versions, edit the `devcontainer.json` file in the `.devcontainer` directory.

## How to contribute

We glady welcome contributions from the community. From updating the documentation to adding more functions for Devstation, all ideas are welcome. Thank you in advance for all of your issues, pull requests, and comments!

- [Contributing guide](./CONTRIBUTING.md)

## Terms of use

https://www.nutanix.com/legal/terms-of-use 