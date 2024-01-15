#!/bin/bash

sshpass -p "0" scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null worker.py emperor@$1:/tmp/worker.py
sshpass -p "0" ssh -t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null emperor@$1 "echo 0 | sudo -S python3 /tmp/worker.py $2"
