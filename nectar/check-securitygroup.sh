#!/bin/bash

for i in `nova list-secgroup $1 | grep -vE '(Id|\+)' | awk '{print $2}'`;do nova secgroup-list-rules $i;done
