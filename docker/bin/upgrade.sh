#!/usr/bin/env bash
# Usage: `./upgrade.sh [<PLATFORM>] [<BEFORE>] [<AFTER>]`
#
# Builds an upgrade process for the puppet-agent module and tags as
# "pa-dev:<PLATFORM>".
#
# Parameters:
# - PLATFORM: The platform on which the upgrade should occur. This also
#             supports comma-separated lists. Available:
#             - `ubuntu`
#             - `rocky`
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
    docker build --rm -f docker/$platform/Dockerfile . -t pa-dev:$platform \
        --build-arg before=${before}
    docker run -e PUPPET_FORGE_TOKEN --rm -ti pa-dev:$platform ${after}
done
echo Complete
