#!/usr/bin/env bash

set -e

to_version="${1}"
if [[ -z "${to_version}" ]]; then
    echo "$0: The version to install must be passed as an argument"
    exit 1
fi
puppet_version=( ${to_version//./ } )
puppet_major=${puppet_version[0]}
case $puppet_major in
    7)
        to_collection=puppet7
        ;;
    8)
        to_collection=puppet8
        ;;
    *)
        echo "$0: Invalid version supplied" 1>&2
        exit 1
esac

export PT__installdir=../
export PT_version=${to_version}
export PT_collection=${to_collection}
export PT_password=${PUPPET_FORGE_TOKEN}
chmod u+x tasks/install_shell.sh
tasks/install_shell.sh

export PATH=/opt/puppetlabs/bin:$PATH
echo "puppet $(puppet --version)"
echo "facter $(facter --version)"
puppet apply -e 'notice("puppet apply")'

os_name=$(facter os.name)
case $os_name in
    Rocky|SLES)
        echo "Installing server"
        puppet apply -e 'package { ["puppetserver", "puppetdb", "puppetdb-termini"]: ensure => installed }'
        dnf list | grep puppet
        ;;
    *)
        echo "Server not supported, skipping"
        ;;
esac

# Make e.g. `puppet --version` work out of the box.
read -p "Explore the container? [y/N]: " choice && \
    choice=${choice:-N} && \
    if [ "${choice}" = "y" ]; then \
        bash; \
    else \
        echo "Moving on..."; \
    fi
