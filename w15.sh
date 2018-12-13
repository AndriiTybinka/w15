#!/bin/bash

touch a.txt
#cp ./a.txt /opt/
cd /opt
touch f1 f2 f3 f4 f5
current_datetime=$(date)
echo "Current date:" $current_datetime
ls -al

while true; do sleep 36; done

