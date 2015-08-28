#!/bin/bash

rsync -avz --exclude-from 'exclude-backup-home-list.txt' /Users/saung /Users/saung/GoFlexPersonal/work-macbook/
