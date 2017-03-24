#!/bin/bash

f=vd6563.1.log


grep -E 'Plugin hook: at discovery start|Plugin hook: at Device Type detected|Plugin hook: at mapping finish' $f

grep -E 'Plugin hook: at object accepted|Plugin hook: at discovery start|Plugin hook: at Device Type detected|Plugin hook: at mapping finish|Plugin hook: at object mapped' $f

grep $f -i -A 5 -e addRelationship -e getObjectsForCoupledDevices
grep -E 'This device has .*[1-9] elements' $f
grep -E 'Found .?[1-9] object' $f -B 1
grep -E 'Retrieved .*[1-9] indicators' $f -n
grep -e '-- Object #' $f | awk {'print $5'} | paste -sd+ | bc


grep -i -e "--- Working on plugin 'Cisco ACI'" -e "Discovery of plugin 'Cisco ACI'" 51_disco.log


plugin_name="SNMP Poller"; grep -i -e "--- Working on plugin '$plugin_name'" -e "Discovery of plugin '$plugin_name'" -n $f 
plugin_name="VMware Poller"; grep -i -e "--- Working on plugin '$plugin_name'" -e "Discovery of plugin '$plugin_name'" -n $f 

grep -i -E 'The object|-- Object #' $f
grep -E 'The object|-- Object #|Retrieved \? indicators' 51_disco.log


#plugin_name="Cisco ACI"; grep -i -e "--- Working on plugin '$plugin_name'" -e "Discovery of plugin '$plugin_name'" 51_disco.log -n
#128:--- Working on plugin 'Cisco ACI'.
#46864:--- Discovery of plugin 'Cisco ACI' succeeded.
#sed -n '128,46864p' 51_disco.log > small_disco.log