#!/usr/bin/env bash

socat tcp4-listen:20002,fork STDOUT  | xargs -d'\n' -IMSG   sh -c " echo 'TCP-->[MSG] {\"'\`date\`'\"}' >> tcplog.txt"
