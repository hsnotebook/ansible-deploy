#!/bin/bash

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

script_home=$(cd $(dirname "${0}"); pwd)

main() {
    docker pull redis:7.2
    docker tag redis:7.2 registry.ctfo.com:5000/redis:7.2
    docker save registry.ctfo.com:5000/redis:7.2 | gzip > ${script_home}/redis.tar.gz
}

main "${@}"
