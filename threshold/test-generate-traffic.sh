#!/bin/bash
# rsync -v -e ssh get_policy_details.sh akarpe571-1:~/code
# file_name=get_threshold_details.sh
# remote_host=ak572-4
# rsync -v -e 'ssh -p 18460'  $file_name root@0.tcp.ngrok.io:/root/code/
#  ssh -p 18460  root@0.tcp.ngrok.io scp /root/code/$file_name  root@$remote_host:~/code/
# rsync -v -e 'ssh -p 18460'  $file_name root@0.tcp.ngrok.io:/root/code/;  ssh -p 18460  root@0.tcp.ngrok.io scp /root/code/$file_name  root@$remote_host:~/code/


# ssh akarpe-ubuntu5

 file_name='/root/DI/DataInsight-Kube-RHEL7.4_v1.3.ova'
 remote_host=ak572-4
ssh-copy-id  $remote_host
 while (true)
 do
    scp -r $file_name $remote_host:/tmp/;
    sleep 1;
 done


remote_host=ak572-4
scp -r $file_name $remote_host:/tmp/;



remote_host=ak572-5
timeout 20s scp -r $file_name $remote_host:/tmp/ | at now
