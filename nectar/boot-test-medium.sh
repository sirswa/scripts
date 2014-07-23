#!/bin/bash

source $HOME/openrc-porting.sh
vname=swe-test-`date +%m%d%H%M`
nova boot --image 26955e70-9da0-44d4-b3f8-e5276e989fdb --flavor test.medium --availability-zone monash-01 --key-name sa --security-group default $vname 

echo "VM name $vname is booted"
