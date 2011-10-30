#!/bin/bash

if [ $(whoami) != "root" ]; then
   echo "You need to be root to run this script"
   exit 1
fi

# Install needed packages
apt-get install -y openjdk-6-jdk
apt-get install -y pkg-config libtool autoconf

# Download jzmq
git clone https://github.com/nathanmarz/jzmq.git

# Compile jzmq
pushd jzmq
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
./autogen.sh
./configure
make
make install
popd

# Remove files
rm jzmq -rf

exit 0