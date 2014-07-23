#!/bin/bash

function progress () {
        i=$1
	for (( c=1; c<=i; c++ ))
	do
       	   sleep 1
           echo -e "+ \c"
	done
}

echo -e "\nRestarting nova-network      \c"
progress 5
/sbin/restart nova-network

echo -e "\nRestarting nova-compute      \c"
progress 5
/sbin/restart nova-compute

echo -e "\nRestarting nova-api-metadata \c"
progress 5
/sbin/restart nova-api-metadata

