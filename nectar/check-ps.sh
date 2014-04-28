#!/bin/bash

instfile=/tmp/instances

sudo virsh list --all |grep inst > $instfile

for i in `cat $instfile |awk '{print $2}'`;do
	    n=`ps -ef |grep $i|grep -v grep | wc -l`
	        cat $instfile |grep $i |awk -v a=$n '{print $2,$3,a}'
	done
