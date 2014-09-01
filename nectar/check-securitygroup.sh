#!/bin/bash

for i in `nova list-secgroup $1 | grep -vE '(Id|\+)' | awk '{print $2}'`;do echo Securty Group ID: $i;nova secgroup-list-rules $i;done
