#!/bin/bash

uniq=`date +%Y%m%d%H%M%S`

idir=/var/lib/nova/instances
vinst=/tmp/virsh-inst.$uniq
used_disk=/tmp/used_disks.$uniq
used_base=/tmp/used_base.$uniq
unused_base=/tmp/unused_base.$uniq

ls $idir |grep -v _base |grep -v compute_nodes |grep -v libvirt-save |grep -v locks |grep -v lost+found |grep -v snapshots > $vinst

for i in `cat $vinst`;do qemu-img info /var/lib/nova/instances/$i/disk |grep backing|awk '{print $3}';done > $used_disk

for i in `cat $vinst`;do qemu-img info /var/lib/nova/instances/$i/disk.local |grep backing|awk '{print $3}';done >> $used_disk
	cat $used_disk |sort -u > $used_disk.tmp ; mv $used_disk.tmp $used_disk
	cat $used_disk |awk -F "/" '{print $7}' > $used_base

ls $idir/_base |grep -v -f $used_base > $unused_base
