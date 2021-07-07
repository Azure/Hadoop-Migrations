#!/bin/sh

if [ $# -lt 2 ]
  then
  	echo "Assigns all required roles to the resource group for given Service Principal"
    echo "roleassign.sh {Service Principal Name} {Resource Group Name}"
    exit
fi

SPNAME=$1
RGNAME=$2

OBJECTID=`az ad sp list --display-name $SPNAME --query "[].{objectId:objectId}" --output tsv`

for i in "Contributor" "Private DNS Zone Contributor" "Network Contributor" "User Access Administrator"
do
  echo "Assigning $i role to Resource Group $RGNAME"
  CMD=`az role assignment create --assignee $OBJECTID --role "$i" --resource-group $RGNAME`
  echo $CMD
  echo ""
done