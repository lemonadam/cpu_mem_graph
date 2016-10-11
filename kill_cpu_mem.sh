#!/bin/bash
pidlist=`ps -a | grep cpu_mem | grep -v grep|wc -l`
for ((j=1;j<=$pidlist;j++));
    do
    pid=`ps -a | grep cpu_mem | grep -v grep | awk '{print $1}' | sed -n "${j}p"`
    echo $pid
    kill -9 $pid
    done