#!/bin/bash

if [ $(whoami) != "root" ]; then
   echo "You need to be root to run this script"
   exit 1
fi

if [ $# -lt 1 ]; then
   echo "usage: 05-config-storm.sh [<numservers>]"
   exit 1
fi

MAX=$1

# Setup conf/storm.yaml

CONFIG=/opt/storm/conf/storm.yaml
echo > $CONFIG  # clear

#
#  storm.zookeeper.servers
#
echo "storm.zookeeper.servers:" >> $CONFIG 
for i in $(seq $MAX); do
   echo " - \"192.168.1.$(expr 200 + $i)\"" >> $CONFIG
done

#
#  storm.local.dir
#
echo >> $CONFIG
mkdir -p /var/storm
cat >> $CONFIG <<EOF
storm.local.dir: "/var/storm"
EOF

#
#  java.library.path
#

#
#  nimbus.host
#
echo >> $CONFIG
echo "nimbus.host: \"192.168.1.201\"" >> $CONFIG

#
#  supervisor.slots.ports
#
cat >> $CONFIG <<EOF

supervisor.slots.ports:
 - 6700
 - 6701
 - 6702
 - 6703

EOF

