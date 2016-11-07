#!/bin/bash
#demo: sh cpu.sh com.ss.android.ugc.live 3  
apkname=$1
delay=$2
for((i=0;i<500;i++));
do
	device_num=`adb devices | grep "device"$ | wc -l`
	for ((j=1;j<=$device_num;j++));
	do
	device_serialname=` adb devices | grep "device"$ | awk '{print $1}' | sed -n "${j}p"`
	echo  ${device_serialname}
	echo $device_num
	function fCPU()
 	{
    
	# echo ----------------------
	pid=`adb -s ${device_serialname} shell ps | grep $apkname | grep -v push|grep -v ttplayer| awk ' {print $2}'`
	# echo $pid
	cpu_all_begin=`adb -s ${device_serialname} shell cat /proc/stat | grep 'cpu[^0-9]' | awk -F' ' '{for(i=2;i<=NF;i++)sum[NR]+=$i;print sum[NR]}'`
	cpu_pro_begin=`adb -s ${device_serialname} shell cat /proc/$pid/stat | awk -F' ' '{for(i=14;i<=15;i++)sum[NR]+=$i;print sum[NR]}'`
	sleep $delay
	cpu_all_end=`adb -s ${device_serialname} shell cat /proc/stat | grep 'cpu[^0-9]' | awk -F' ' '{for(i=2;i<=NF;i++)sum[NR]+=$i;print sum[NR]}'`
	cpu_pro_end=`adb -s ${device_serialname} shell cat /proc/$pid/stat | awk -F' ' '{for(i=14;i<=15;i++)sum[NR]+=$i;print sum[NR]}'`
	cpu_all=`expr $cpu_all_end - $cpu_all_begin`
	# echo $cpu_all
	cpu_pro=`expr $cpu_pro_end - $cpu_pro_begin`
	# echo $cpu_pro
	cpu_utilization=`awk 'BEGIN{printf "%.2f\n",'$cpu_pro'/'$cpu_all'}'`
    `echo $cpu_utilization >>${device_serialname}_cpu.log`
    # echo $cpu_utilization;
 	}
	if [ "$device_num" -eq 1 ]
    then
    # echo $device_num"++++++++___________"
    fCPU
	echo "deviceid--->"$device_serialname"----->获取数据条数 $i"
    continue
    else
    	if [ "$j" -eq "$device_num" ]
    	then
    	fCPU
		else
		fCPU&
		fi
	fi
	done
done

