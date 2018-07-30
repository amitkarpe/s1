#!/bin/bash
# rsync -v -e ssh get_policy_details.sh akarpe571-1:~/code
# file_name=get_threshold_details.sh
# remote_host=ak572-4
# rsync -v -e 'ssh -p 18460'  $file_name root@0.tcp.ngrok.io:/root/code/
#  ssh -p 18460  root@0.tcp.ngrok.io scp /root/code/$file_name  root@$remote_host:~/code/
# rsync -v -e 'ssh -p 18460'  $file_name root@0.tcp.ngrok.io:/root/code/;  ssh -p 18460  root@0.tcp.ngrok.io scp /root/code/$file_name  root@$remote_host:~/code/

threshold_id=$1

#mysqldata -te "select * from local.thresholds where thresholds.id =$threshold_id "
#mysqldata -te "select * from local.thresholds_conditions where threshold_id=$threshold_id "
mysqldata -te "select * from alerts where threshold_id=$threshold_id"

echo List all active alerts
mysqldata -te "select * from alerts where threshold_id=$threshold_id and closed=0 "

echo List all closed alerts
mysqldata -te "select * from alerts where threshold_id=$threshold_id and closed=1 "

echo List all ignored alerts
mysqldata -te "select id, closed, FROM_UNIXTIME(start_time) as start_time, FROM_UNIXTIME(end_time) as end_time, comments, ackd_by, number, \
FROM_UNIXTIME(last_processed) as last_processed, FROM_UNIXTIME(ignore_until) as ignore_until, ignore_uid from alerts \
where threshold_id=$threshold_id order by start_time"
