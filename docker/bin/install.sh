#!/usr/bin/env bash
# Usage: `./install.sh [<PLATFORM>] [<VERSION>]`
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
version=${2:-8.10.0}
for platform in ${platforms//,/ }
do
    case $platform in
        amazon)
            base_image='amazonlinux:2023'
            ;;

        fedora)
            base_image='fedora:40'
            ;;

        rocky)
            base_image='rockylinux/rockylinux:8'
            ;;

        sles)
            docker build --rm -f docker/sles/Dockerfile . -t pa-dev:$platform.install \
                   --build-arg version=${version}
            docker run -e PUPPET_FORGE_TOKEN --rm -ti pa-dev:$platform.install
            exit 0
            ;;

        *)
            echo "$0: Usage install.sh [amazon|fedora|rocky]"
            exit 1
            ;;
    esac

    docker build --rm -f docker/install/dnf/Dockerfile . -t pa-dev:$platform.install \
           --build-arg version=${version} \
           --build-arg BASE_IMAGE=${base_image}
    docker run -e PUPPET_FORGE_TOKEN --rm -ti pa-dev:$platform.install
done
echo Complete
