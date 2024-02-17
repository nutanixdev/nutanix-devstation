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

- [x] Python v3.12.x
- [x] Calm DSL latest
- [x] Ansible v2.16.3 (pip v9.2.0)
- [x] Terraform v1.5.5
- [x] PowerShell v7.4.1
- [x] Packer v1.9.2
- [x] Kubectl v1.29.2
- [x] Helm v3.14.1
- [x] minikube v1.32.0
- [x] Kubectl-karbon v0.11.5
- [x] OpenShift CLI (oc) v4.14.11
- [x] OpenShift Install CLI v4.14.11
- [x] Clusterctl v1.6.1
- [x] k9s v0.31.9
- [x] Cookiecutter v2.5.0
- [x] GitHub CLI v2.44.1
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

### Version 0.4.0

- Python updated to version 3.12

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