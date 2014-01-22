#!/bin/bash

source $HOME/openrc-porting.sh
vname=sa-prec-`date +%m%d%H%M`
nova boot --image 374bfaec-70ad-4d84-9c08-c03938b2de41 --flavor m1.small --availability-zone monash-01 --key-name sa --security-group default $vname 

echo "VM name $vname is booted"
