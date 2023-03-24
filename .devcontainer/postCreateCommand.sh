#!/usr/bin/env bash

if kubectl krew > /dev/null 2>&1
then
    kubectl krew install karbon
fi

if command -v pwsh > /dev/null 2>&1
then
    pwsh -Command Install-Module Nutanix.Cli -Force
fi