#!/bin/bash

echo "Enter Report Start Date (Format example: 2014-01-01)"
read SDAY_INPUT
sday=$SDAY_INPUT

echo "Enter Report End Date (Format example: 2014-01-31)"
read EDAY_INPUT
eday=$EDAY_INPUT

month=$sday-$eday

echo "Enter the nova database name"
read DB_INPUT
DB=$DB_INPUT

echo "Getting data from $sday to $eday"
echo ""

report=$month.report.csv
ddir=`pwd`/$month

CMD="/usr/bin/mysql -e"

$CMD "use $DB;select uuid, user_id, project_id,
    UNIX_TIMESTAMP(IF(created_at < '$sday 00:00:00','$sday 00:00:00',created_at)) as 'Create_at',
    UNIX_TIMESTAMP(IF(deleted_at >= '$eday 23:59:59','$eday 23:59:59',COALESCE(deleted_at,'$eday 23:59:59'))) as 'Delete_at',
    vcpus, memory_mb, host

    from instances
    where
    (created_at BETWEEN '$sday 00:00:00' AND '$eday 23:59:59')
        OR (created_at < '$sday 00:00:00' AND deleted_at BETWEEN '$sday 00:00:00' AND '$eday 23:59:59')
        OR (created_at < '$sday 00:00:00' AND deleted_at IS NULL)
        OR (created_at < '$sday 00:00:00' AND deleted_at > '$eday 23:59:59') "| tr '\t' ', ' > $month.csv

cat $month.csv| tail -n+2 > $month.rawdata

rawdata=$month.rawdata

projectids=$month.projectids

cat $rawdata |awk -F, '{print $3}' |sort -u > $projectids

project_usage=$month.project.usage

for i in `cat $projectids`;do
    awk -v x=$i -F, '$3 == x {s+=($5-$4)*$6;inst++;vcpu+=$6} END {print x","s/3600","inst","vcpu}' $rawdata
done > $project_usage

cat $project_usage |sort -t "," -k2,2rn > $project_usage.tmp
mv $project_usage.tmp $project_usage

echo "Specify project and institute lookup csv file with full path(For example: /tmp/project-lookup.csv)"
read CSV_INPUT

echo $month > $month-usage-report.csv
echo "No of VMs,Cores hour,Project Institute,Project Name,Project ID" >> $month-usage-report.csv
for i in `cat $project_usage`;do
    prid=`echo $i | awk -F, '{print $1}'`
    prusagehr=`echo $i | awk -F, '{print $2}'`
    prvm=`echo $i | awk -F, '{print $3}'`
    prcores=`echo $i | awk -F, '{print $4}'`
    prinst=`cat $CSV_INPUT |grep -w $prid |awk -F, '{print $1","$2}'`
    echo $prvm,$prusagehr,$prinst,$prid >> $month-usage-report.csv
    done