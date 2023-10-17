#!/bin/bash
SCRIPT_HOME=`cd $(dirname $0); pwd`

echo "Collect superset images..."

echo "    pull superset images..."
docker pull redis:7 > /dev/null
docker pull postgres:14 > /dev/null
docker pull apachesuperset.docker.scarf.sh/apache/superset:2.1.0 > /dev/null

rm -f ${SCRIPT_HOME}/superset-images.tar.gz

echo "    save superset images..."
docker save \
    redis:7 \
    postgres:14 \
    apachesuperset.docker.scarf.sh/apache/superset:2.1.0 \
| gzip --stdout > ${SCRIPT_HOME}/superset-images.tar.gz
