#!/bin/bash

cd /opt
touch f1 f2 f3 f4 f5
current_datetime=$(date)
echo "Current date:" $current_datetime
ls -al

