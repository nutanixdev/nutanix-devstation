# Nutanix DevStation

A toolkit container for automating Nutanix and its applications, deploying Kubernetes, and operating the platform at scale.

## Features

- Cross-platform: Windows and Mac (Intel or Apple silicon) are validated.
- Works with Docker Desktop and Rancher Desktop (dockerd - moby).

---
**NOTE**

Windows users must clone the repo using the following command to avoid issues with `CRLF`.

```console
git clone https://github.com/nutanixdev/nutanix-devstation.git --config core.autocrlf=false
```

---

## Tools included

### CLIs

- [x] Python v3.11.x
- [x] Calm DSL v3.6.1
- [x] Ansible v2.14.3 (pip v7.3.0)
- [x] Terraform v1.4.1
- [x] PowerShell v7.3.3
- [x] Packer v1.8.6
- [x] Kubectl v1.26.2
- [x] Helm v3.11.2
- [x] minikube v1.29.0
- [x] Kubectl-karbon v0.9.6
- [x] OpenShift CLI (oc) v4.12.6
- [x] OpenShift Install CLI v4.12.6
- [x] Clusterctl v1.3.5
- [x] k9s v0.27.3
- [x] Cookiecutter v2.1.1
- [x] GitHub CLI v2.25.1
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

The Nutanix DevStation doesn't ship a container image, instead it builds a local image in your computer based on the settings in the `devcontainer.json` file included in the `.devcontainer` directory.

When opening a project in VS Code that includes the `.devcontainer` directory, the Dev Container extension prompts the option for building the container. Then the project folder is mounted inside the container. The content of the project folder is always available regardless of opening it locally or in the container.

Additionally, two container volumes are used for persisting Calm DSL cache and bash history after rebuilding the container when making changes to `devcontainer.json`.

## How to use

You only need the `.devcontainer` directory in the project root folder:

1. Clone or download the repository.

1. Copy or move the `.devcontainer` directory to your project.

1. To enable/disable or configure different tool versions, edit the `devcontainer.json` file in the `.devcontainer` directory.

## How to contribute

We glady welcome contributions from the community. From updating the documentation to adding more functions for DevStation, all ideas are welcome. Thank you in advance for all of your issues, pull requests, and comments!

- [Contributing guide](./CONTRIBUTING.md)

## Terms of use

https://www.nutanix.com/legal/terms-of-use 

## CHANGELOG

### Version 0.2.0

This version is EA and has been tested with different OSes and container engines.

### Version 0.1.x

0.1.x versions were the initial version of the Nutanix DevStation and used internally for demos.