#!/bin/bash
SCRIPT_HOME=`cd $(dirname $0); pwd`

echo "Collect pgRouting package..."

cd ${SCRIPT_HOME}

wget https://github.com/Kitware/CMake/releases/download/v3.28.0-rc3/cmake-3.28.0-rc3-linux-x86_64.tar.gz
wget https://nchc.dl.sourceforge.net/project/boost/boost/1.66.0/boost_1_66_0.tar.bz2
wget -O pgrouting-3.5.1.tar.gz https://github.com/pgRouting/pgrouting/archive/v3.5.1.tar.gz
