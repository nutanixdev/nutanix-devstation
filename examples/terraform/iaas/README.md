# Introduction

Terraform configuration for Nutanix's Flow Virtual Networking. Flow Virtual Networking must be enabled prior to running this configuration.
This configuration creates an External VLAN subnet, two VPC's, four Overlay subnets that attaches to the VPC's, four VM's that will use each subnet and two Floating IP's.

# How to Use
---

1) Update ./terraform.tfvars with the required details.
There are four values to be added:
    - NUTANIX_USERNAME 
    - NUTANIX_PASSWORD 
    - NUTANIX_ENDPOINT
    - IMAGE_NAME         # An existing image in the cluster that will be used to create the VM's

2) Run these commands to kickoff the deployment.
    - terraform init
    - terraform plan
    - terraform apply

