#!/bin/bash
days=1
polling_number=1
random=`shuf -i 1-10000 -n 1`
directory_name=/tmp/$random
mkdir $directory_name
if [ "$#" -lt 1 ];then
    echo "";echo "Usage: $0 <device_id> <object_id> ";echo "";
	echo "OR";echo "";
	echo "Usage: $0 -i [For interactive mode]";echo "";exit;
	echo "";exit;
else
	if [ "$1" == "-i" ];then
		clear; echo "This is interactive mode."	
		read -p "Enter Device ID : " device_name
		read -p "Enter Object ID : " object_name
		device_id=$(mysqldata -BNe "select id from net.deviceinfo where name regexp '$device_name' limit 1")
		device_ip=$(mysqlconfig -BNe "select pe.ip from peers as pe join deviceinfo as di on di.peer=pe.server_id where di.id=$device_id");
		object_id=$(mysqldata -h $device_ip -BNe "select id from local.device_object where device_id=$device_id and name regexp '$object_name'  limit 1")		
	else
	clear; echo "This is non-interactive mode."	
	device_id=$(mysqldata -BNe "select id from net.deviceinfo where name regexp '$1' limit 1")
	device_ip=$(mysqlconfig -BNe "select pe.ip from peers as pe join deviceinfo as di on di.peer=pe.server_id where di.id=$device_id");
	object_id=$(mysqldata -h $device_ip -BNe "select id from local.device_object where device_id=$device_id and name regexp '$2'  limit 1");
	fi
fi

device_ip=$(mysqlconfig -BNe "select pe.ip from peers as pe join deviceinfo as di on di.peer=pe.server_id where di.id=$device_id");
plugin_object_type_id=$(mysqldata -h $device_ip -BNe "select plugin_object_type_id from local.device_object where device_id=$device_id and id=$object_id")
if [ -z "$device_ip" ];then
	echo ""; echo "Error: Please provide IP address of peer which is polling this device by using interactive mode."; echo ""; exit;		
fi
echo "Debug: Device ID $device_id, Object ID $object_id, Object Type ID $plugin_object_type_id,  Peer IP $device_ip"
mysqldata -h $device_ip -e "select * from local.device_object where device_id=$device_id and id=$object_id" 
mysqldata -h $device_ip -e "select * from local.device_indicator where device_id=$device_id and object_id=$object_id" 

echo ""; echo local.device_object_ext_snmp
mysqldata -h $device_ip -e "select * from local.device_object_ext_snmp where object_id=$object_id and device_id=$device_id"
echo local.device_indicator_ext_snmp
mysqldata -h $device_ip -e "select * from local.device_indicator_ext_snmp where indicator_id in (select id from local.device_indicator where device_id=$device_id and object_id=$object_id) "

echo ""; echo net.plugin_object_type_ext_snmp
mysqldata -h $device_ip -e "select * from net.plugin_object_type_ext_snmp where plugin_object_type_id=$plugin_object_type_id"

echo net.plugin_indicator_type_ext_snmp
mysqldata -h $device_ip -e "select * from net.plugin_indicator_type_ext_snmp where plugin_indicator_type_id in (select plugin_indicator_type_id from local.device_indicator where device_id=$device_id and object_id=$object_id)"
#mysqldata -e "select * from net.plugin_indicator_type_ext_snmp pites left join net.plugin_indicator_type pit   on pites.plugin_indicator_type_id = pit.id where plugin_object_type_id=$plugin_object_type_id"

index_oid=$(mysqldata -h $device_ip -BNe "select $index_oid from net.plugin_object_type_ext_snmp where plugin_object_type_id=$plugin_object_type_id")
echo $index_oid
description_oid=$(mysqldata -h $device_ip -BNe "select $description_oid from net.plugin_object_type_ext_snmp where plugin_object_type_id=$plugin_object_type_id")
echo $description_oid
name_oid=$(mysqldata -h $device_ip -BNe "select $name_oid from net.plugin_object_type_ext_snmp where plugin_object_type_id=$plugin_object_type_id")
echo $name_oid
echo $oid
echo $device_name
#snmpget -v 2c -c sevone $device_name .1.3.6.1.2.1.25.3.3.1.2.196608
snmpwalk -v 2c -c sevone $device_name $index_oid
#snmpget -v 2c -c sevone $device_name .1.3.6.1.2.1.15.3

exit
echo ""; echo net.deviceinfo
mysqldata -h $device_ip -e "select id, mgt_address, name, peer  from net.deviceinfo where id=$device_id"

echo ""; echo local.device_object
mysqldata -h $device_ip -e "select * from local.device_object where device_id=$device_id and id=$object_id" 

echo ""; echo local.device_indicator
mysqldata -h $device_ip -e "select * from local.device_indicator where device_id=$device_id and object_id=$object_id" 
echo ""; echo local.device_object join local.device_indicator
mysqldata -h $device_ip -e "select do.id, do.device_id, do.plugin_object_type_id, do.name, do.description, table_name, plugin_indicator_type_id, column_name, maximum_value, format, synthetic_expression from local.device_object do join local.device_indicator di on do.id=di.object_id where do.device_id=$device_id and do.id=$object_id order by plugin_indicator_type_id" 
#echo ""; echo net.plugin_indicator_type
#mysqldata -h $device_ip -e "select id, name, description, format, allow_maximum_value, data_units, display_units, synthetic_expression from net.plugin_indicator_type where plugin_object_type_id=$plugin_object_type_id order by id" 

table_name=$(mysqldata -h $device_ip -BNe "select distinct table_name from local.device_object do join local.device_indicator di on do.id=di.object_id where do.device_id=$device_id and di.object_id=$object_id")
#read -ra column_name <<< $(mysqldata -h $device_ip -BNe "select column_name from local.device_object do join local.device_indicator di on do.id=di.object_id where do.device_id=$device_id and di.object_id=$object_id")

echo ""; echo Last 5 polling data from pluginlongterm.$table_name
mysqldata -h $device_ip -e "select *, FROM_UNIXTIME(time, '%Y-%d-%m  %h:%i') as Date_Time from pluginlongterm.$table_name where time between UNIX_TIMESTAMP()-(60*60*3) and UNIX_TIMESTAMP() order by time desc limit 5" 

ssh $device_ip rm /var/lib/mysql-files/$device_id.$object_id._data.csv
mysqldata -h $device_ip -e "select *, FROM_UNIXTIME(time, '%Y-%d-%m  %h:%i') as Date_Time from pluginlongterm.$table_name where time between UNIX_TIMESTAMP()-( 60 * 60 * 24 * $days ) and UNIX_TIMESTAMP() INTO OUTFILE '/var/lib/mysql-files/$device_id.$object_id._data.csv' FIELDS ENCLOSED BY '\"' TERMINATED BY ',' LINES TERMINATED BY '\n';" 
scp $device_ip:/var/lib/mysql-files/$device_id.$object_id._data.csv $directory_name

if [ "$3" == "-d" ];then
	
	echo "";echo "Running SevOne-discover-devices";echo ""; 
	ssh $device_ip SevOne-discover-devices discover-now  $device_id --verbose-discovery 2>&1 > $directory_name/$device_id.discovery.log
	echo "";echo "Running SevOne-poll-now";echo "";
	ssh $device_ip time SevOne-poll-now --device $device_id --plugin $plugin_id --object $object_id --request-limit $polling_number --debug 2>&1 > $directory_name/$device_id.poll.log
	
	echo ""; echo "Please collect SevOne-discover-devices logs from $directory_name/$device_id.discovery.log";
	echo ""; echo "Please collect SevOne-poll-now logs from $directory_name/$device_id.discovery.log"; 
fi

echo ""; echo "Please collect raw data from  $directory_name/$device_id.$object_id._data.csv"; 
echo ""; echo "Please review these newly created files in $directory_name"; echo ""; 
ls -lh $directory_name

#mysqldata -e "select id,name,mgt_address from net.deviceinfo where id=$device_id" 
#echo ""; echo device_object_metadata 
#mysqldata -h $device_ip -e "select * from local.device_object_metadata where device_id=$device_id and object_id=$object_id" 

