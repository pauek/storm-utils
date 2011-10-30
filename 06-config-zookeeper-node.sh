#!/bin/bash

# Configurable parameters

IPBASE="192.168.1"
GATEWAY="192.168.1.1"

# Parse command line

if [ $# -lt 2 ]; then
   echo "usage: storm-config.sh <number> <maxnumber> [<net-interface>]"
   exit 1
fi

MYID=$1
MAX=$2
INTERFACE=$3

if [ -z $INTERFACE ]; then
  # Attempt auto-detection
  INTERFACE=$(ifconfig -a -s | grep eth | cut -d' ' -f1)
fi

#
#  Step 1:
#  Change network configuration
#
cat > /etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto $INTERFACE
iface $INTERFACE inet static
   address ${IPBASE}.$(expr 200 + $MYID)
   netmask 255.255.255.0
   gateway ${GATEWAY}
EOF

#
#  Step 2:
#  Change hostname
#
echo "storm"${MYID} > /etc/hostname

#
#  Step 3:
#  Change hosts file
#
cat > /etc/hosts << EOF
127.0.0.1       localhost
127.0.1.1       storm${MYID}
EOF

for i in $(seq $MAX); do
  echo ${IPBASE}.$(expr 200 + $i) storm$i
done >> /etc/hosts

cat >> /etc/hosts << EOF
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

#
#  Step 4:
#  Change zookeeper myid
#
echo $MYID > /etc/zookeeper/conf/myid

#
#  Step 5:
#  Change zookeeper configuration
#
cat > /etc/zookeeper/conf/zoo.cfg <<EOF
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/var/lib/zookeeper
clientPort=2181
EOF

for i in $(seq $MAX); do
   echo "server.$i=storm$i:2888:3888" >> /etc/zookeeper/conf/zoo.cfg
done

