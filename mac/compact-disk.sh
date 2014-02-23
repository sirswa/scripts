#!/bin/sh
diskutil unmountDisk force /Volumes/Personal
hdiutil compact /Users/saung/Copy/Personal-4GB-1.sparseimage
diskutil unmountDisk force /Volumes/work
hdiutil compact /Users/saung/Copy/work-4GB-1.sparseimage
