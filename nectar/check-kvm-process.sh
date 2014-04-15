for i in `virsh list --all |grep instance |awk '{print $2}'`
do
	echo "$i \c"; ps -ef|grep $i|grep -v grep |wc -l
done
