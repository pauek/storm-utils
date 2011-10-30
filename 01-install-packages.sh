#!/bin/bash

if [ $(whoami) != "root" ]; then
   echo "You need to be root to run this script"
   exit 1
fi

apt-get install -y python2.6 openjdk-6-jdk unzip