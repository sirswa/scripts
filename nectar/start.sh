service puppet start
start nova-api-metadata
sleep 5
start nova-network
sleep 5
start nova-compute
