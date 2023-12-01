#!/bin/bash
app_home=`cd $(dirname $0); pwd`

if [[ "$1" = "bash" ]]
then
    docker run --rm -it \
        -v $app_home:/repos \
        repo-creator:anolis \
        bash
    exit 0
fi

if [[ $# -lt 1 ]]
then
    echo "Usage: $0 <repo_name> <package_name ...>"
    exit 1
fi

repo_name=$1
shift
packages=$@

docker run --rm \
    -v $app_home:/repos \
    --name repo-creator \
    repo-creator:anolis \
    $repo_name $packages
