#!/bin/bash

if [ -z "$1" ]; then
   usage: "storm-config.sh <number> <maxnumber> [<net-interface>]"
   exit 1
fi

MYID=$1
MAX=$2
INTERFACE=$3

if [ -z $INTERFACE ]; then
  INTERFACE="eth0"
fi

IPBASE="192.168.1"
GATEWAY="192.168.1.1"

# Change network configuration
cat > /etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto $ETHX
iface $ETHX inet static
   address ${IPBASE}.$(expr 200 + $MYID)
   netmask 255.255.255.0
   gateway ${GATEWAY}
EOF

# Change hostname
echo "storm"${MYID} > /etc/hostname

# Change hosts file
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

# Change zookeeper myid
echo $MYID > /etc/zookeeper/conf/myid

# Change zookeeper configuration
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

