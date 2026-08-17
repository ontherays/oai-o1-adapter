#!/bin/bash
# ==============================================================================
# Script: native_build.sh
# Purpose: Automates dependency installation and native build for OAI O1-Adapter
# Execution: Run as root or with sudo
# ==============================================================================

set -e # Exit immediately if a command exits with a non-zero status

echo ">>> Updating system and installing essential build tools..."
apt-get update && apt-get upgrade -y
apt-get install -y tzdata build-essential git cmake pkg-config unzip wget \
  libpcre2-dev zlib1g-dev libssl-dev autoconf libtool

echo ">>> Installing NETCONF required daemons and tools..."
apt-get install -y --no-install-recommends psmisc unzip wget openssl \
  openssh-client vsftpd openssh-server

echo ">>> Creating netconf system user..."
if id "netconf" &>/dev/null; then
    echo "User netconf already exists."
else
    adduser --system netconf && echo "netconf:netconf!" | chpasswd
fi

echo ">>> Fetching O1-Adapter source code..."
if [ ! -d "oai-o1-adapter" ]; then
    git clone https://gitlab.eurecom.fr/oai/o1-adapter.git oai-o1-adapter
fi
cd oai-o1-adapter
chmod -R +x .

echo ">>> Installing NETCONF dependencies (libssh, libyang, sysrepo, netopeer2)..."
./docker/scripts/netconf_dep_install.sh
ldconfig

echo ">>> Configuring netopeer2 hostkeys and configs..."
/usr/local/share/netopeer2/merge_hostkey.sh
/usr/local/share/netopeer2/merge_config.sh

echo ">>> Retrieving and installing O1 YANG Models from 3GPP..."
./docker/scripts/get-yangs.sh
./docker/scripts/install-yangs.sh

echo ">>> Compiling the O1-Adapter binary..."
cd src
./build.sh

echo ">>> Native build completed successfully. The adapter binary is ready."