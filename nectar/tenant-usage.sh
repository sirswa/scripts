#!/bin/bash
# 2015-03-19
# This is used to extract project usage for Sebastian

sdate=2000-01-01
edate=2015-03-18

echo Project ID,Project Name,Expiry Date,VMs,RAM MB-Hrs,CPU Hrs,Disk GB-Hrs,Members
for i in `cat tenant-list.allocation.id.20150318`;do

	keystone tenant-get $i > tenants/$i
	nama=`cat tenants/$i |grep -w name |awk '{print $4}'`
	tid=`cat tenants/$i |grep -w id | awk '{print $4}'`
	expiredate=`cat tenants/$i |grep -w expires | awk '{print $4}'`

	keystone user-list --tenant $i |grep "@" | awk -v ORS=";" '{print $8}'| sed 's/,$/\n/'> tenants/$i.members
	
	nova usage --tenant $i |awk 'NR ==5 {print $2","$4","$6","$8}' > tenants/$i.usage
	if [[ -s tenants/$i.usage ]];then
		echo $i,$nama,$expiredate,`cat tenants/$i.usage`,`cat tenants/$i.members`
	else
		echo $i,$nama,$expiredate,0,0,0,0,`cat tenants/$i.members`
	fi

done


