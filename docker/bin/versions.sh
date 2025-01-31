#!/usr/bin/env bash
# Usage: `./upgrade.sh [<PLATFORM>] [<BEFORE>] [<AFTER>]`
#
# Outputs the package versions of puppet-agent that are available on a given
# platform.
#
# Parameters:
# - PLATFORM: The platform on which the upgrade should occur. Available:
#             - `ubuntu`
#             - `rocky`
#             Default: `ubuntu`
set -e

if [ -z "${PUPPET_FORGE_TOKEN}" ]; then
    echo "Environment variable PUPPET_FORGE_TOKEN must be set"
    exit 1
fi

platform=${1:-rocky}

case "${platform}" in
    ubuntu|rocky)
        ;;
    *) echo "Invalid platform: '${platform}'. Must be 'ubuntu' or 'rocky'"
        exit 1
        ;;
esac
cd "$(dirname "$0")/../.."
docker build --rm -f docker/${platform}/Dockerfile.versions . -t pa-dev:${platform}-versions
docker run -e PUPPET_FORGE_TOKEN --rm -it pa-dev:${platform}-versions
