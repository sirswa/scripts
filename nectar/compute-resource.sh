#!/bin/sh
# Swe Aung, 2013-08-14

#FILE=/Users/saung/data/NeCTAR/credentials/nova.cnf

#Set your mysql client path
#CMD="/usr/local/bin/mysql --defaults-file=$FILE -e"
CMD="/usr/local/bin/mysql -e"

#Set your database name
DB=nova_monash_01

echo ""
echo "Compute nodes resources"
$CMD "use $DB;
	select hypervisor_hostname,running_vms as 'VMs', vcpus_used as 'Used',46 - vcpus_used as 'Free', disk_available_least as 'Disk'
			from compute_nodes
				order by hypervisor_hostname
					";
