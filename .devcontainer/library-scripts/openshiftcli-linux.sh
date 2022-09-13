#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
#
# Based on: https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/terraform.md
# Maintainer: Jose Gomez - Nutanix
#
# Syntax: ./openshiftcli-linux.sh [openshift version] [openshift SHA]

set -e

OPENSHIFT_CLI_VERSION="${1:-"latest"}"
OPENSHIFT_CLI_SHA256="${2:-"automatic"}"

REDHAT_GPG_KEY="199E2F91FD431D51"
GPG_KEY_SERVERS="keyserver hkp://keyserver.ubuntu.com:80
keyserver hkps://keys.openpgp.org
keyserver hkp://keyserver.pgp.com"

architecture="$(uname -m)"
case ${architecture} in
    x86_64) architecture="amd64";;
    aarch64 | armv8*) architecture="arm64";;
    aarch32 | armv7* | armvhf*) architecture="arm";;
    i?86) architecture="386";;
    *) echo "(!) Architecture ${architecture} unsupported"; exit 1 ;;
esac

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Get central common setting
get_common_setting() {
    if [ "${common_settings_file_loaded}" != "true" ]; then
        curl -sfL "https://aka.ms/vscode-dev-containers/script-library/settings.env" 2>/dev/null -o /tmp/vsdc-settings.env || echo "Could not download settings file. Skipping."
        common_settings_file_loaded=true
    fi
    if [ -f "/tmp/vsdc-settings.env" ]; then
        local multi_line=""
        if [ "$2" = "true" ]; then multi_line="-z"; fi
        local result="$(grep ${multi_line} -oP "$1=\"?\K[^\"]+" /tmp/vsdc-settings.env | tr -d '\0')"
        if [ ! -z "${result}" ]; then declare -g $1="${result}"; fi
    fi
    echo "$1=${!1}"
}

# Import the specified key in a variable name passed in as 
receive_gpg_keys() {
    get_common_setting $1
    local keys=${!1}
    get_common_setting GPG_KEY_SERVERS true
    local keyring_args=""
    if [ ! -z "$2" ]; then
        keyring_args="--no-default-keyring --keyring $2"
    fi

    # Use a temporary locaiton for gpg keys to avoid polluting image
    export GNUPGHOME="/tmp/tmp-gnupg"
    mkdir -p ${GNUPGHOME}
    chmod 700 ${GNUPGHOME}
    echo -e "disable-ipv6\n${GPG_KEY_SERVERS}" > ${GNUPGHOME}/dirmngr.conf
    # GPG key download sometimes fails for some reason and retrying fixes it.
    local retry_count=0
    local gpg_ok="false"
    set +e
    until [ "${gpg_ok}" = "true" ] || [ "${retry_count}" -eq "5" ]; 
    do
        echo "(*) Downloading GPG key..."
        ( echo "${keys}" | xargs -n 1 gpg -q ${keyring_args} --recv-keys) 2>&1 && gpg_ok="true"
        if [ "${gpg_ok}" != "true" ]; then
            echo "(*) Failed getting key, retring in 10s..."
            (( retry_count++ ))
            sleep 10s
        fi
    done
    set -e
    if [ "${gpg_ok}" = "false" ]; then
        echo "(!) Failed to get gpg key."
        exit 1
    fi
}

# Ensure apt is in non-interactive to avoid prompts
export DEBIAN_FRONTEND=noninteractive

mkdir -p /tmp/openshift-downloads
cd /tmp/openshift-downloads

# Install OpenShift CLI
echo "Downloading oc..."
oc_filename="openshift-client-linux.tar.gz"
# oc_filename="openshift-client-linux-4.11.0.tar.gz"
curl -sSL -o ${oc_filename} "https://mirror.openshift.com/pub/openshift-v4/${architecture}/clients/ocp/${OPENSHIFT_CLI_VERSION}/${oc_filename}"

if [ "${OPENSHIFT_CLI_SHA256}" != "dev-mode" ]; then
    if [ "${OPENSHIFT_CLI_SHA256}" = "automatic" ]; then
        receive_gpg_keys REDHAT_GPG_KEY
        curl -sSL -o OPENSHIFT_CLI_SHA256 https://mirror.openshift.com/pub/openshift-v4/${architecture}/clients/ocp/${OPENSHIFT_CLI_VERSION}/sha256sum.txt
        curl -sSL -o OPENSHIFT_CLI_SHA256.gpg https://mirror.openshift.com/pub/openshift-v4/${architecture}/clients/ocp/${OPENSHIFT_CLI_VERSION}/sha256sum.txt.gpg
        # gpg --verify OPENSHIFT_CLI_SHA256.gpg < OPENSHIFT_CLI_SHA256
    else
        echo "${OPENSHIFT_CLI_SHA256} *${oc_filename}" > OPENSHIFT_CLI_SHA256
    fi
    # sha256sum --ignore-missing -c OPENSHIFT_CLI_SHA256
fi

tar -xzf ${oc_filename}
mv -f oc /usr/local/bin/

rm -rf /tmp/openshift-downloads ${GNUPGHOME}
echo "Done!"