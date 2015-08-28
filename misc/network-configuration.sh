#Set hostname
hostnamectl set-hostname lb01-server.example.com
 
#Remove all network configuration
nmcli con del eno{1,2,3,4}
 
#Configure bonding
nmcli con add type bond con-name bond0 ifname bond0 mode active-backup
nmcli con add type bond-slave con-name eno1 ifname eno1 master bond0
nmcli con add type bond-slave con-name eno2 ifname eno2 master bond0
 
#Configure bridging, IPs, DNS, 
nmcli con add type bridge con-name br1169 ifname br1169 ip4 10.0.0.226/24 gw4 10.0.0.1
nmcli con mod br1169 ipv4.dns "10.0.0.141 10.0.0.142"
nmcli con mod br1169 ipv4.dns-search "example.com"
 
#Configure VLANs
nmcli con add type bridge-slave con-name bond0.1169 ifname bond0.1169 master br1169
nmcli con add type bridge-slave con-name bond0.1170 ifname bond0.1170 master br1170
nmcli con add type bridge-slave con-name bond0.1261 ifname bond0.1261 master br1261
 
#NetworkManager can not bridge VLANs in RHEL7 - so here is a workaround:
sed -i 's/^TYPE=.*/TYPE=Vlan/' /etc/sysconfig/network-scripts/ifcfg-bond0.{1170,1261,1169}
echo "VLAN=yes" >> /etc/sysconfig/network-scripts/ifcfg-bond0.1169
echo "VLAN=yes" >> /etc/sysconfig/network-scripts/ifcfg-bond0.1170
echo "VLAN=yes" >> /etc/sysconfig/network-scripts/ifcfg-bond0.1261
 
reboot
