#!/bin/sh

if [ $# -lt 2 ]
  then
    echo "Loads and stores ssh public key from current user home (~/.ssh/id_rsa.pub) to Resource Group"
    echo "load-publi-key.sh {Resource Group Name} {ssh key name}"
    echo ""
    exit
fi

RG1=$1
SK1=$2
KS1=`cat ~/.ssh/id_rsa.pub`

az deployment group create -g $RG1 \
 -f modules/create-sshkey/azuredeploy.bicep \
 --parameters modules/create-sshkey/azuredeploy.parameters.json \
 --parameters sshKeyName=$SK1 sshKeyValue="${KS1}"
