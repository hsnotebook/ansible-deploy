#!/bin/bash

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

deploy_home=$(cd $(dirname "${0}"); pwd)

main() {
    rsync -av --delete ${deploy_home}/ lhasa2-tool:/root/deploy
}

main "${@}"
