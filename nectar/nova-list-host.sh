nova list --all-tenants --host $1 --fields OS-EXT-SRV-ATTR:instance_name,user_id,tenant_id,flavor,status
