#!/bin/bash

for i in engineering dev content flight;
do
      oc new-project $i
done
