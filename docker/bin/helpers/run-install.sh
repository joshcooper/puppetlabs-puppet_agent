#!/usr/bin/env bash

set -e

to_version=${1:-8.10.0}
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
        echo "Invalid version supplied" 1>&2
        exit 1
esac

export PT__installdir=../
export PT_version=${to_version}
export PT_password=${PUPPET_FORGE_TOKEN}
chmod u+x tasks/install_shell.sh
tasks/install_shell.sh

echo "puppet $(/opt/puppetlabs/puppet/bin/puppet --version)"
echo "facter $(/opt/puppetlabs/puppet/bin/facter --version)"
/opt/puppetlabs/puppet/bin/puppet apply -e 'notice("puppet apply")'
