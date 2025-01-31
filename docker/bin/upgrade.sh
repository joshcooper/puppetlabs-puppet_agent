#!/usr/bin/env bash
# Usage: `./upgrade.sh [<PLATFORM>] [<BEFORE>] [<AFTER>]`
#
# Builds an upgrade process for the puppet-agent module and tags as
# "pa-dev:<PLATFORM>".
#
# Parameters:
# - PLATFORM: The platform on which the upgrade should occur. This also
#             supports comma-separated lists. Available:
#             - `amazon`
#             - `fedora`
#             - `rocky`
#             - `sles`
#             - `ubuntu`
#             Default: `ubuntu`
# - BEFORE: The puppet-agent package version that is installed prior to upgrade.
#           Default: 7.34.0
# - AFTER: The puppet-agent package version that should exist after upgrade.
#          Default: 8.1.0
set -e

if [ -z "${PUPPET_FORGE_TOKEN}" ]; then
    echo "Environment variable PUPPET_FORGE_TOKEN must be set"
    exit 1
fi

cd "$(dirname "$0")/../.."
platforms=${1:-rocky}
before=${2:-7.34.0}
after=${3:-8.10.0}
for platform in ${platforms//,/ }
do
    case $platform in
        amazon)
            base_image='amazonlinux:2023'
            release_package='http://yum.puppet.com/puppet7-release-amazon-2023.noarch.rpm'
            ;;

        fedora)
            base_image='fedora:40'
            release_package='http://yum.puppet.com/puppet7-release-fedora-40.noarch.rpm'
            ;;

        rocky)
            base_image='rockylinux/rockylinux:8'
            release_package='http://yum.puppet.com/puppet7-release-el-8.noarch.rpm'
            ;;

        sles)
            docker build --rm -f docker/sles/Dockerfile . -t pa-dev:$platform \
                   --build-arg before=${before}
            docker run -e PUPPET_FORGE_TOKEN --rm -ti pa-dev:$platform 8.10.0
            exit 0
            ;;

        *)
            echo "$0: Usage upgrade.sh [amazon|fedora|rocky]"
            exit 1
            ;;
    esac

    docker build --rm -f docker/upgrade/dnf/Dockerfile . -t pa-dev:$platform \
           --build-arg before=${before} \
           --build-arg BASE_IMAGE=${base_image} \
           --build-arg RELEASE_PACKAGE=${release_package}

    docker run -e PUPPET_FORGE_TOKEN --rm -ti pa-dev:$platform ${after}
done
echo Complete
