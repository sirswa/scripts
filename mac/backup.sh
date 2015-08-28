#!/bin/bash

rsync -avz --exclude-from 'exclude-backup-list.txt' /Users/saung /Volumes/iomega/officemac-backup
