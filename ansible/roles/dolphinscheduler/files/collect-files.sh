#!/bin/bash
SCRIPT_HOME=`cd $(dirname $0); pwd`

cd ${SCRIPT_HOME}

echo "Collect dolphinscheduler images..."

echo "    pull dolphinscheduler images..."
docker pull bitnami/postgresql:11.11.0 > /dev/null
docker pull bitnami/zookeeper:3.6.2 > /dev/null
docker pull apache/dolphinscheduler-tools:3.1.8 > /dev/null
docker pull apache/dolphinscheduler-api:3.1.8 > /dev/null
docker pull apache/dolphinscheduler-alert-server:3.1.8 > /dev/null
docker pull apache/dolphinscheduler-master:3.1.8 > /dev/null
docker pull apache/dolphinscheduler-worker:3.1.8 > /dev/null

rm -f ${SCRIPT_HOME}/dolphinscheduler-images.tar.gz

echo "    save dolphinscheduler images..."
docker save \
    bitnami/postgresql:11.11.0 \
    bitnami/zookeeper:3.6.2 \
    apache/dolphinscheduler-tools:3.1.8 \
    apache/dolphinscheduler-api:3.1.8 \
    apache/dolphinscheduler-alert-server:3.1.8 \
    apache/dolphinscheduler-master:3.1.8 \
    apache/dolphinscheduler-worker:3.1.8 \
| gzip --stdout > ${SCRIPT_HOME}/dolphinscheduler-images.tar.gz

echo "    download datax..."
wget https://datax-opensource.oss-cn-hangzhou.aliyuncs.com/202303/datax.tar.gz
