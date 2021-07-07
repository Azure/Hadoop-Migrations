#!/bin/sh

if [ $# -lt 1 ]
  then
    echo "Removes all resources of given resource group. It actually doesn't remove anything"
    echo "rmall.sh {Resource Group Name} [{Regex on Resource Name} [{Regex on Resource Type}]]"
    echo "  Regex on Resource Name, Optional : python regex search pattern, case ignored"
    echo "    ex. ^vm-us- lists all names starts with vm-us-"
    echo "        ip$ lists all names ends with ip"
    echo "        disk lists all names contains disk"
    echo "  Regex on Resource Type, Optional : same regex on type"
    echo ""
    exit
fi

RGNAME=$1
ARG1=$2
ARG2=$3

JST1=`az resource list --resource-group $RGNAME`
#JST1=`cat 1.txt`
echo "$JST1" | python3 -c "
import sys, json, re;

nameCond = ''
typeCond = ''
if len(sys.argv) > 1 :
  nameCond = sys.argv[1]
if len(sys.argv) > 2 :
  typeCond = sys.argv[2]
p1 = re.compile(nameCond, re.IGNORECASE)
p2 = re.compile(typeCond, re.IGNORECASE)

jso = json.load(sys.stdin)
buf2 = ''
print('* Listing all matched resources to remove')
for rcs in jso:
  ##print(rcs['name'], rcs['type'])
  ##buf = \"az resource delete --resource-group %s -name %s --resource-type %s \" % ('TEST1', rcs['name'], rcs['type'])
  ##buf = \"az resource delete --ids %s \" % (rcs['id'])
  #buf2 += \"%s \" % (rcs['id'])
  id = rcs['id']
  name = rcs['name']
  type = rcs['type']
  if p1.search(name):
    print(name, type)
    buf2 += \"%s \" % (id)

print()
print('* Run this from your command line')
print(\"az resource delete --ids %s\" % (buf2))
print()
" $ARG1 $ARG2
