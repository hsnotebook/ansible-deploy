#!/bin/bash
SCRIPT_HOME=`cd $(dirname $0); pwd`

echo "Collect nifi package..."

cd ${SCRIPT_HOME}

rm -f ${SCRIPT_HOME}/jdbc
rm -f ${SCRIPT_HOME}/nifi-1.23.2-bin.zip

echo "    download nifi-1.23.2-bin.zip"
wget https://dlcdn.apache.org/nifi/1.23.2/nifi-1.23.2-bin.zip

echo "    download jdbc drivers"
mkdir jdbc
cd jdbc

wget https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.1.0/mysql-connector-j-8.1.0.jar
wget https://repo1.maven.org/maven2/org/postgresql/postgresql/42.6.0/postgresql-42.6.0.jar
wget https://repo1.maven.org/maven2/com/oracle/database/jdbc/ojdbc10/19.20.0.0/ojdbc10-19.20.0.0.jar
