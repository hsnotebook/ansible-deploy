#!/bin/bash
SCRIPT_HOME=`cd $(dirname $0); pwd`

echo "Collect activemq package..."

cd ${SCRIPT_HOME}

rm -f ${SCRIPT_HOME}/apache-activemq-5.18.2-bin.tar.gz

echo "    download activemq tar.gz"
wget https://dlcdn.apache.org//activemq/5.18.2/apache-activemq-5.18.2-bin.tar.gz -O ${SCRIPT_HOME}/apache-activemq-5.18.2-bin.tar.gz
