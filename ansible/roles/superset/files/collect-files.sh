#!/bin/bash
SCRIPT_HOME=`cd $(dirname $0); pwd`

echo "Collect superset images..."
rm -f ${SCRIPT_HOME}/superset-images.tar.gz

echo "    pull superset images..."
docker pull redis:7 > /dev/null
docker pull postgres:14 > /dev/null
docker pull apachesuperset.docker.scarf.sh/apache/superset:3.0.2 > /dev/null

cat << EOF > ${SCRIPT_HOME}/Dockerfile
FROM apachesuperset.docker.scarf.sh/apache/superset:3.0.2
USER root
RUN pip install starrocks cx_Oracle clickhouse-connect impyla trino
USER superset
EOF

docker build -t apachesuperset.docker.scarf.sh/apache/superset:3.0.2 -f ${SCRIPT_HOME}/Dockerfile .

echo "    save superset images..."
docker save \
    redis:7 \
    postgres:14 \
    apachesuperset.docker.scarf.sh/apache/superset:3.0.2 \
| gzip --stdout > ${SCRIPT_HOME}/superset-images.tar.gz
