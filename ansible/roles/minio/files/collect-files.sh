#!/bin/bash
SCRIPT_HOME=`cd $(dirname $0); pwd`

echo "Collect minio package..."

cd ${SCRIPT_HOME}

rm -f ${SCRIPT_HOME}/minio.rpm

echo "    download minio rpm"
wget https://dl.min.io/server/minio/release/linux-amd64/archive/minio-20231007150738.0.0.x86_64.rpm -O ${SCRIPT_HOME}/minio.rpm

rm -f ${SCRIPT_HOME}/mc
echo "    download mc"
wget https://dl.min.io/client/mc/release/linux-amd64/mc
