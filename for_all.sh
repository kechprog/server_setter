#!/bin/bash

# Check if subnet is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <subnet>"
    exit 1
fi

subnet=$1

# Function to perform an ARP scan
get_local_ips() {
    # Using arp-scan to find active hosts in the subnet
    # This requires arp-scan to be installed
    # Replace enp2s0 with your network interface name
    arp-scan --localnet --interface=enp2s0 | grep -E "([a-f0-9]{2}:){5}[a-f0-9]{2}"
}

deploy() {
    sshpass -p "0" scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 worker.py emperor@$1:/tmp/worker.py </dev/null
    sshpass -p "0" ssh -tt -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 emperor@$1 "echo 0 | sudo -S python3 /tmp/worker.py $2" </dev/null
}

active_hosts=$(get_local_ips $subnet)

counter=0

while read -r line
do
    ip=$(echo $line | awk '{print $1}')
    mac=$(echo $line | awk '{print $2}')

    echo "Working on: $ip"

	read -p "Run? (y/n) " yn < /dev/tty
    case $yn in
        [Yy]* ) deploy $ip $((counter++));;
        [Nn]* ) echo "Skipping...";;
        * ) echo "Please answer yes or no.";;
    esac
done <<< "$active_hosts"
