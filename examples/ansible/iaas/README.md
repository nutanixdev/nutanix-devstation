# Introduction

Ansible playbook for Nutanix's Flow Virtual Networking. Flow Virtual Networking must be enabled prior to running this playbook.
This playbook creates an External VLAN subnet, two VPC's, four Overlay subnets that attaches to the VPC's, four VM's that will use each subnet and two Floating IP's.

# How to Use
---

1) Update iaas.yaml with Prism Central endpoint details.
There are three values to be added:
    - nutanix_host 
    - nutanix_username 
    - nutanix_password

2) Update the image_name in ./roles/vm/tasks/main.yml that will be used to create the VM's.

3) Update the cluster name in ./roles/vm/vars/main.yml and ./roles/external_subnet/vars/main.yml

4) Run this command to kickoff the deployment - ansible-playbook iaas.yml
