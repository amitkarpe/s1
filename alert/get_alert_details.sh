#!/bin/bash

// TODO: Test on live
// TODO: test on ubuntu

alert=$1
echo ""; echo Alert;
mysqlconfig -te "select * from alerts where id=$alert"

threshold_id=$(mysqlconfig -BNe "select threshold_id from alerts where id=$alert")
dev_id=$(mysqlconfig -BNe "select dev_id from alerts where id=$alert")
dev_id=$(mysqlconfig -BNe "select dev_id from alerts where id=$alert")
peer_id=$(mysqlconfig -BNe "select peer from deviceinfo where id=$dev_id")
peer_ip=$(mysqlconfig -BNe "select ip from peers where server_id=$peer_id")
policy_id=$(mysqldata -h $peer_ip -BNe "select policy_id from local.thresholds where id=$threshold_id")

#mysqlconfig -BNe "select * from policy where id=$policy_id"

#mysqldata -e "select id as 'Policy ID', name as 'Policy Name',  group_id , is_device_group AS Yes, object_type_id, trigger_expression AS Trigger_Ex, clear_expression AS clear from policy where id=$policy_id"
echo ""; echo Policy;
mysqldata -te "select id, name, is_device_group as 'D G', group_id, object_type_id, trigger_expression as 'Trigger', FROM_UNIXTIME(last_updated) as 'Updated', type, clear_expression AS clear, trigger_message as 'Msg', append_condition_messages as 'Append' from net.policy where id=$policy_id"
echo ""; echo Policy;
mysqldata -te "select id, name, is_device_group as 'D G', group_id, object_type_id, trigger_expression as 'Trigger', FROM_UNIXTIME(last_updated) as 'Updated', type, clear_expression AS clear, trigger_message as 'Msg', append_condition_messages as 'Append' from net.policy where id=$policy_id"

#mysqldata -te "select id as 'Policy ID', name as 'Policy Name', description As Descr, group_id , is_device_group AS Yes, object_type_id, trigger_expression AS Trigger_Ex, clear_expression AS clear from policy where id=$policy_id"
#mysqldata -te "select id as 'Group ID', name as 'Device Group Name' from net.devicetags where id in (select group_id from policy where id=$policy_id)"
#mysqldata -te "select id as 'Device ID',name as 'Device Name',mgt_address from net.deviceinfo where id in (select device_id from net.device_devicetag_map where devicetag_id in (select group_id from policy where id=$policy_id))"

echo ""; echo Thresholds;
mysqldata -h $peer_ip -te "select * from local.thresholds where id=$threshold_id"
echo ""; echo Thresholds Conditions;
mysqldata -h $peer_ip -te "select * from local.thresholds_conditions where threshold_id=$threshold_id"
echo ""; echo Policy Conditions;
mysqldata -te "select * from net.policyconditions where id in (select policy_condition_id from local.thresholds_conditions where threshold_id=$threshold_id)"

indicator_id=$(mysqldata -h $peer_ip -BNe "select poll_id from local.thresholds_conditions where threshold_id=$threshold_id limit 1")
export indicator_id
echo $indicator_id

mysqlconfig -tve "select * from alerts where id=$alert" >> policy_id-${policy_id}_alert_id-${alert}.log
mysqldata -tve "select * from net.policy where id=$policy_id" >> policy_id-${policy_id}_alert_id-${alert}.log
mysqldata -tve "select * from net.policyconditions where id in (select policy_condition_id from local.thresholds_conditions where threshold_id=$threshold_id)" >> policy_id-${policy_id}_alert_id-${alert}.log
mysqldata -h $peer_ip -tve "select * from local.thresholds where id=$threshold_id" >> policy_id-${policy_id}_alert_id-${alert}.log
mysqldata -h $peer_ip -tve "select * from local.thresholds_conditions where threshold_id=$threshold_id" >> policy_id-${policy_id}_alert_id-${alert}.log
mysqldata -tve "select * from net.devicetags where id in (select group_id from policy where id=$policy_id)" >> policy_id-${policy_id}_alert_id-${alert}.log
mysqldata -tve "select id as 'Device ID', name as 'Device Name', mgt_address, peer from net.deviceinfo where id in (select device_id from net.device_devicetag_map where devicetag_id in (select group_id from policy where id=$policy_id))" >> policy_id-${policy_id}_alert_id-${alert}.log
echo ""
echo "Redirected all results @ "  policy_id-${policy_id}_alert_id-${alert}.log
ls -lh policy_id-${policy_id}_alert_id-${alert}.log
echo ""
exit
