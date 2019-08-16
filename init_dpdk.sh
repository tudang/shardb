#!/bin/bash

if [ -z ${RTE_SDK} ]; then
	echo "Please set \$RTE_SDK variable"
	echo "sudo -E ./setup.sh"
	exit -1
fi

function ins_uio() {
  sudo modprobe uio
  sudo insmod $RTE_SDK/$RTE_TARGET/kmod/igb_uio.ko
  $RTE_SDK/usertools/dpdk-devbind.py --status
}

function reserve_hugepage() {
  sudo mkdir -p /mnt/huge
  sudo mount -t hugetlbfs nodev /mnt/huge/
  sudo bash -c 'echo 2048 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages'
  if [ -d "/sys/devices/system/node/node1" ] ; then
    sudo bash -c 'echo 2048 > /sys/devices/system/node/node1/hugepages/hugepages-2048kB/nr_hugepages'
  fi
}

function bind_intf_to_uio() {
  sudo ip link set dev $INTF down
  $RTE_SDK/usertools/dpdk-devbind.py --bind=igb_uio $INTF
}


INTF=""
SKIP_SETUP=0

while getopts "h?i:s" opt; do
  case $opt in
    i) INTF=$OPTARG
				;;
    s) SKIP_SETUP=1
				;;
  esac
done

echo $INTF
if [ -z "$INTF" ] ; then
	echo "Please provide the interface name"
	echo "e.g, sudo -E ./init_dpdk.sh -i eth0"
	exit -1
fi

if [ $SKIP_SETUP -eq 0 ]; then
   ins_uio
   reserve_hugepage
   bind_intf_to_uio
   exit
else
  bind_intf_to_uio
  exit
fi
