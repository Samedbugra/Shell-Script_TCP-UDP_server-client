#!/usr/bin/env bash

socat udp4-listen:10001,fork STDOUT | xargs -IMSG sh -c " echo 'UDP-->[MSG] {\"'\`date\`'\"} ' >> udplog.txt"
