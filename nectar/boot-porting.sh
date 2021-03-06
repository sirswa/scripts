#!/bin/bash

source $HOME/openrc-porting.sh
vname=sa-prec-`date +%m%d%H%M`
nova boot --image 19050113-9643-4d4a-a154-cb21066ffe3b --flavor m1.small --availability-zone monash-01 --key-name sa --security-group default $vname 

echo "VM name $vname is booted"
