#!/bin/bash
set -e
eval "$(jq -r '@sh "VERSION_PREFIX=\(.version_prefix) SUPPORTED_VERSIONS=\(.supported_versions)"')"

## Supported versions are listed earliest to latest.  Iterate over list
## to find the latest version matching the given version prefix.
the_latest=""
for version in `echo ${SUPPORTED_VERSIONS} | sed 's/,/ /g'`; do
    if [ -z "${VERSION_PREFIX}" ]; then
        ## Specific version prefix not provided; Use last version in list
        the_latest=${version}
    elif [[ ${version} == ${VERSION_PREFIX}* ]]; then
        ## Version begins with specified prefix; Record as potential latest version
        the_latest=${version}
    fi
done
jq -n --arg latest_version "$the_latest" '{latest_version:($latest_version)}'
