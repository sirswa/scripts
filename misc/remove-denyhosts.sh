#!/bin/sh
 
HOST=$1
 
cd /var/lib/denyhosts
for i in `ls`; do mv $i $i.old; grep -v $HOST $i.old >> $i; done
 
cp /etc/hosts.deny /tmp/hosts.deny
grep -v $HOST /tmp/hosts.deny > /etc/hosts.deny
