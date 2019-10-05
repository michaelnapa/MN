#!/bin/bash

#grab ipinfo on computer to determine network location
ipinfo=$(ifconfig | grep "inet 10.")
echo $ipinfo
ipsubnet=$(echo ${ipinfo:6:5})
echo $ipsubnet
