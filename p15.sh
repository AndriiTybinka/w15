#!/bin/bash

datetime=$(date)
user=$(whoami)
host=$(hostname)

logTemplate='{"Datetime":"%s"
		, "User":"%s"
		, "Host":"%s"
		, "CpuInfo":{"UserMain":"%s"
				, "NiceD":"%s"
				, "Idle":"%s"	
				, "Iowait":"%s"
				, "Irq":"%s"
				, "Softirq":"%s"
				, "Steal":"%s"
				}
		, "CpuUsage":"%s"
		, "Status":"%s"
		}'

createFile(){
    local datetime=$(date +%s)
    local fileName="${datetime}_${host}.json"
    
    touch $fileName
	chmod 640 $fileName
	   

    generateCpuInfo $fileName
}

generateCpuInfo(){
		local userMain=`cat /proc/stat | grep -w cpu | awk '{print($2)}'`
		local niceD=`cat /proc/stat | grep -w cpu | awk '{print($3)}'`
		local idle=`cat /proc/stat | grep -w cpu | awk '{print($4)}'`
		local iowait=`cat /proc/stat | grep -w cpu | awk '{print($5)}'`
		local irq=`cat /proc/stat | grep -w cpu | awk '{print($6)}'`
		local softirq=`cat /proc/stat | grep -w cpu | awk '{print($7)}'`
		local steal=`cat /proc/stat | grep -w cpu | awk '{print($8)}'`

		let local "totalCPUTimeSinceBoot=$user + $nice + $system + $idle +$iowait + $irq + $softirq + $steal"
			echo $totalCPUTimeSinceBoot
		let local "totalCPUIdleTimeSinceBoot=$iowait + $idle"
		let local "totalCPUUsageTimeSinceBoot=$totalCPUTimeSinceBoot - $totalCPUIdleTimeSinceBoot"
		local cpuUsage=$(echo "scale=8; $totalCPUUsageTimeSinceBoot / $totalCPUTimeSinceBoot * 100" | bc)
			echo $cpuUsage
		#let local "cpuUsageIf=$cpuUsage / 1"		
			echo $cpuUsageIf
		if (( $(echo "$cpuUsage < 50.0" |bc -l) )); then 
			local status='normal'
		else
			local status='critical'
		fi
			echo $status

		local infoJsonF=$(printf "$logTemplate" "$datetime" "$user" "$host" "$userMain" "$niceD" "$idle" "$iowait" "$irq" "$softirq" "$steal" "$cpuUsage" "$status")
    
   		echo $infoJsonF > $1
    
    		if [ $? -eq 0 ]; then
   			echo "===> $(date) log $1 created"
    		else
   			echo "===> $(date) something wrong"
   		fi    
}

while true; do
    createFile
    sleep 300
done

