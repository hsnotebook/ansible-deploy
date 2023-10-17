#!/bin/bash
SCRIPT_HOME=`cd $(dirname $0); pwd`
cd ${SCRIPT_HOME}

echo "Collect ansible collections..."

rm -f *.tar.gz

echo "    download ansible-posix..."
wget https://galaxy.ansible.com/download/ansible-posix-1.5.4.tar.gz -O ansible-posix-1.5.4.tar.gz

echo "    download community-general..."
wget https://galaxy.ansible.com/download/community-general-7.4.0.tar.gz -O community-general-7.4.0.tar.gz
