#!/bin/bash

echo "Following command willcopy ssh keys on all nodes"

ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''

list="master node1 workstation"


for host in $list
do
    echo $host;
    ssh-copy-id $host;
done
