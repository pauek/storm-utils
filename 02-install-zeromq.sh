#!/bin/bash

if [ $(whoami) != "root" ]; then
   echo "You need to be root to run this script"
   exit 1
fi

# Download needed packages
apt-get install -y build-essential uuid-dev

# Download zeromq
wget http://download.zeromq.org/historic/zeromq-2.1.7.tar.gz
tar xzvf zeromq-2.1.7.tar.gz

# Compile zeromq
pushd zeromq-2.1.7
./configure
make 
make install
popd

# Remove tmp files
rm zeromq-2.1.7* -rf

exit 0