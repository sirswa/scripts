#!/bin/bash

tstamp=`date +%Y%m%d%H%M%S`

# controller id
cid=0

# number of pdisk

# number of vdisk
nvd=12

for i in `seq 0 $nvd`;do 
	vdid=$i
	/opt/dell/srvadmin/bin/omreport storage vdisk controller=$cid vdisk=$vdid > vdisk.$vdid.$tstamp

	cat vdisk.$vdid.$tstamp |grep -q Critical 
	if [ $? -eq 0 ]
	then
		dname=`cat vdisk.$vdid.$tstamp |grep "Device Name" |awk -F ": " '{print $2}'`
		/opt/dell/srvadmin/bin/omreport storage pdisk controller=$cid vdisk=$vdid > pdisk.$vdid.$tstamp

		sno=`cat pdisk.$vdid.$tstamp |grep "Serial" |awk -F ": " '{print $2}'`
		pdid=`cat pdisk.$vdid.$tstamp |grep -w "ID" |head -n1 |awk -F ":" '{print $4}'`

		smartctl -a -d megaraid,$pdid $dname > smartctl.$vdid.$pdid.$tstamp
		vdor=`cat smartctl.$vdid.$pdid.$tstamp |grep Vendor |awk '{ sub(/^[ \t]+/, "");print $2}'`
		hname=`hostname|awk -F "-ac" '{print $1}'`
		status=`cat vdisk.$vdid.$tstamp |grep "Critical" |awk '{ sub(/^[ \t]+/, "");print $3}'`
		echo $hname,$dname,$sno,$vdor,$status
	fi


done
