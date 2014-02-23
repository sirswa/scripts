#!/bin/bash

HOME_NETWORK=192.168
HOME_GATEWAY=192.168.1.1
WORK_NETWORKS="118.138.240.0/21 172.16.90.0/21"

# What should the DNS servers be set to?
DNS_SERVERS="203.12.160.35 203.12.160.36"

##
## Do not edit below this line if you do not know what you are doing.
##
function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

# Nuke any DENY firewall rules
for RULE in `sudo ipfw list | grep deny | awk '{print $1}' | xargs`; do sudo ipfw delete $RULE; done

# Delete any routes for the home network that Anyconnect might have made
sudo route delete -net ${HOME_NETWORK}
sudo route add -net ${HOME_NETWORK} ${HOME_GATEWAY}

# Get the AnyConnect interface
ANYCONNECT_INTERFACE=`route get 0.0.0.0 | grep interface | awk '{print $2}'`

# Add the work routes
for NETWORK in ${WORK_NETWORKS}; do
    sudo route -nv add -net ${NETWORK} -interface ${ANYCONNECT_INTERFACE}
done

# Set the default gateway
sudo route change default ${HOME_GATEWAY}

# Mass route changes
for NET in `netstat -nr | grep -e ^${HOME_NETWORK} | grep utun1 | awk '{print $1}' | xargs`; do 
    if valid_ip ${NET}; then
        echo "Changing route for network"
        sudo route change ${NET} ${HOME_GATEWAY}
    else
        echo "Changing route for host"
        sudo route change -net ${NET} ${HOME_GATEWAY}
    fi      
done

# Set the nameservers
sudo scutil << EOF
open
d.init
d.add ServerAddresses * ${DNS_SERVERS}
set State:/Network/Service/com.cisco.anyconnect/DNS
quit
EOF
###
