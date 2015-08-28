keystone tenant-get $1 |grep name |awk '{print $4}'
keystone user-list --tenant $1
