#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

	scratch=$(mktemp -d -t tmp.XXXXXXXXXX)	
	arg1="${1:-}"
	arg2="${2:-}"
	device_id=$arg1
	days=30
	echo $arg1 $arg2
	device_file_name="device.d${device_id}_log"
	log_file="/tmp/device_${device_id}.disco.log"
	#echo $device_file_name; echo $log_file
	peer_ip=$(mysqlconfig -BNe "select pe.ip from peers as pe join deviceinfo as di on di.peer=pe.server_id where di.id=$device_id");

function init()
{
	clear
}
function fun1()
{
	echo device_id $device_id
	echo ""; echo Collecting data from net.deviceinfo; 
	mysqldata -h $peer_ip -e "select id, mgt_address, name, peer from net.deviceinfo where id=$device_id" --table --verbose -vvv >> $log_file

	echo ""; echo Collecting data from local.device_object_metadata; 
	mysqldata -h $peer_ip -e "select * from local.device_object_metadata where device_id=$device_id" --table --verbose -vvv >> $log_file

	echo ""; echo Collecting data from local.device_object; 
	mysqldata -h $peer_ip -e "select * from local.device_object where device_id=$device_id" --table --verbose -vvv >> $log_file

	echo ""; echo Collecting data from local.device_indicator; 
	mysqldata -h $peer_ip -e "select * from local.device_indicator where device_id=$device_id" --table --verbose -vvv >> $log_file

	echo ""; echo Collecting data from $device_file_name; 
	mysqldata -h $peer_ip -e "select id, FROM_UNIXTIME(time, '%Y-%d-%m  %h:%i') as Date_Time, type, level, message from $device_file_name where time between UNIX_TIMESTAMP()-( 60 * 60 * 24 * $days ) and UNIX_TIMESTAMP() order by time desc"  --table --verbose -vvv >> $log_file

	echo ""; 
	echo Please copy $log_file and upload on case page. Please press enter !!!
	echo "";
}

function fun2()
{
	echo fun2
}

function finish {
	rm -rf "$scratch"
	echo Exiting from function!
}