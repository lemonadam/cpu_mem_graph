#!/bin/bash
#demo: sh cpu.sh com.ss.android.ugc.live 3  
apkname=$1
delay=$2
for((i=0;i<100;i++));
do
	device_num=`adb devices | grep "device"$ | wc -l`
	for ((j=1;j<=$device_num;j++));
	do
	device_serialname=` adb devices | grep "device"$ | awk '{print $1}' | sed -n "${j}p"`
	echo  ${device_serialname}
	echo $device_num
	if [ "$device_num" -eq 1 ]
    then
    echo $device_num"++++++++___________"
    `adb -s ${device_serialname} shell top -n 1 -d $2 | grep $1  |awk '{s+=$3} END {print s}' >>${device_serialname}_cpu.log`
	echo "deviceid--->"$device_serialname"----->获取数据条数 $i"
    continue
    else
    	if [ "$j" -eq "$device_num" ]
    	then
    	`adb -s ${device_serialname} shell top -n 1 -d $2 | grep $1  |awk '{s+=$3} END {print s}' >>${device_serialname}_cpu.log`
		else
		`adb -s ${device_serialname} shell top -n 1 -d $2 | grep $1  |awk '{s+=$3} END {print s}' >>${device_serialname}_cpu.log`&
		fi
	fi
	done
done