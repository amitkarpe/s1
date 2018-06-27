#!/bin/bash
# rsync -v -e ssh get_policy_details.sh akarpe571-1:~/code
# file_name=get_threshold_details.sh
# remote_host=ak572-4
# rsync -v -e 'ssh -p 18460'  $file_name root@0.tcp.ngrok.io:/root/code/
#  ssh -p 18460  root@0.tcp.ngrok.io scp /root/code/$file_name  root@$remote_host:~/code/
# rsync -v -e 'ssh -p 18460'  $file_name root@0.tcp.ngrok.io:/root/code/;  ssh -p 18460  root@0.tcp.ngrok.io scp /root/code/$file_name  root@$remote_host:~/code/
clear

threshold_id=$1

mysqldata -te "select * from local.thresholds where thresholds.id =$threshold_id "
mysqldata -te "select * from local.thresholds_conditions where threshold_id=$threshold_id "
mysqldata -te "select * from alerts where threshold_id=$threshold_id"

exit
