# Nutanix Dev Station

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
- [x] Calm DSL v3.7.0
- [x] Ansible v2.14.11 (pip v7.3.0)
- [x] Terraform v1.5.5
- [x] PowerShell v7.3.9
- [x] Packer v1.9.2
- [x] Kubectl v1.28.3
- [x] Helm v3.13.1
- [x] minikube v1.31.2
- [x] Kubectl-karbon v0.11.4
- [x] OpenShift CLI (oc) v4.14.1
- [x] OpenShift Install CLI v4.14.1
- [x] Clusterctl v1.5.3
- [x] k9s v0.27.4
- [x] Cookiecutter v2.4.0
- [x] GitHub CLI v2.38.0
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

The Nutanix Dev Station doesn't ship a container image, instead it builds a local image in your computer based on the settings in the `devcontainer.json` file included in the `.devcontainer` directory. It uses the Microsoft Visual Studio Code Dev Containers extension, and we just provide a standard configuration file with several tools enabled. You can customize it adding, updating, or removing tools.

When opening a project in VS Code that includes the `.devcontainer` directory, the Dev Container extension prompts the option for building the container. Then the project folder is mounted inside the container. The content of the project folder is always available regardless of opening it locally or in the container.

Additionally, two container volumes are used for persisting Calm DSL cache and bash history after rebuilding the container when making changes to `devcontainer.json`.

## How to use

### Quick Install

1. Clone, or download and extract the repository.

2. Open the folder in VS Code and when prompted, click `Reopen in Container`.

3. Enjoy the Nutanix Dev Station!

### Re-use Dev Containers in another project

You only need the `.devcontainer` directory in the project root folder:

1. Clone, or download and extract the repository.

2. Copy or move the `.devcontainer` directory to your project.

### Advanced Settings

To enable/disable or configure different tool versions, edit the `devcontainer.json` file in the `.devcontainer` directory.

## How to contribute

We gladly welcome contributions from the community. From updating the documentation to adding more functions for Dev Station, all ideas are welcome. Thank you in advance for all of your issues, pull requests, and comments!

- [Contributing guide](./CONTRIBUTING.md)

## Terms of use

https://www.nutanix.com/legal/terms-of-use 

## CHANGELOG

### Version 0.3.0

- Support for persistent user profile (.calm and .nutanixdev volumes are migrated to a new one)
- Tool versions have been updated.
- Fix zsh history.
- Include detailed changelog file.
- Update and include new Nutanix SDKs for Nutanix Disaster Recovery, Microseg and Networking.
- Normalization (LF and CRLF)

### Version 0.2.0

This version is EA and has been tested with different OSes and container engines.

### Version 0.1.x

0.1.x versions were the initial version of the Nutanix Dev Station and used internally for demos.