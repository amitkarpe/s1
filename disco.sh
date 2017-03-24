#!/bin/bash

clear
device_id=$1
days=30
device_file_name="device.d${device_id}_log"
log_file="/tmp/device_${device_id}.disco.log"
#echo $device_file_name; echo $log_file

echo ""; echo Collecting data from net.deviceinfo; 
mysqldata -e "select id, mgt_address, name, peer from net.deviceinfo where id=$device_id" --table --verbose -vvv >> $log_file

echo ""; echo Collecting data from local.device_object_metadata; 
mysqldata -e "select * from local.device_object_metadata where device_id=$device_id" --table --verbose -vvv >> $log_file

echo ""; echo Collecting data from local.device_object; 
mysqldata -e "select * from local.device_object where device_id=$device_id" --table --verbose -vvv >> $log_file

echo ""; echo Collecting data from local.device_indicator; 
mysqldata -e "select * from local.device_indicator where device_id=$device_id" --table --verbose -vvv >> $log_file

echo ""; echo Collecting data from $device_file_name; 
mysqldata -e "select id, FROM_UNIXTIME(time, '%Y-%d-%m  %h:%i') as Date_Time, type, level, message from $device_file_name where time between UNIX_TIMESTAMP()-( 60 * 60 * 24 * $days ) and UNIX_TIMESTAMP() order by time desc"  --table --verbose -vvv >> $log_file

echo ""; 
echo Please copy $log_file and upload on case page. Please press enter !!!
echo ""; 
read

exit 0;