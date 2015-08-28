#!/bin/bash
bdir=/root/instance-libvirtxml
idir=/var/lib/nova/instances

for i in `ls -l $idir|egrep -v "_base|libvirt-save|locks|lost|snapshots|total" |awk '{print $9}'`;do
	mkdir -p $bdir/$i
	cp -rp $idir/$i/libvirt.xml $bdir/$i/
done

cp -rp /etc/libvirt/nwfilter $bdir/
