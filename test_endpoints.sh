#!/bin/bash

[[ "$#" == "1" ]] || {
    echo "Please provide the server name or IP address as only argument"
    exit 1
}

SERVER="${1}"

# public directory
curl -s "http://${SERVER}/"

# basicauth directory
curl -s -u vagrant-ansible-libvirt:vagrant-ansible-libvirt "http://${SERVER}/basicauth/"

# secret directory using basic auth user
curl -s -u vagrant-ansible-libvirt:vagrant-ansible-libvirt "http://${SERVER}/secret/"
