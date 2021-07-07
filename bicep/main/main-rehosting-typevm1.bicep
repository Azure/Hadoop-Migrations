//// Parameters

@description('Location to create all resources')
param location string = resourceGroup().location

@description('Project name')
param projectName string = 'hdmp001'

param keyString string

param identifier int

param suffix string

param tmpString string = utcNow('yyyyMMddHHmmss')

//// Variables

var vLocation = location
var vProjectName = projectName
var vKeyString = keyString

var vVNetName = '${vProjectName}vnet001'
var vNSGName = '${vProjectName}nsg001'

var uniqueString = tmpString
var VMName = toLower('${vProjectName}${suffix}-${uniqueString}')
var diskName = toLower('${VMName}-disk${uniqueString}')

module stgDisk '../modules/create-disk/azuredeploy.bicep' = {
  name: 'create-disk-${suffix}'
  params: {
    location: vLocation
    diskName: diskName
    diskSizeGB: 5
    diskSKU: 'Premium_LRS' 
  }
}

// VM Creations, head nodes
module stgVMType1 '../modules/create-vm-simple-linux-with-data-disk/azuredeploy.bicep' = {
  name: 'create-node-${suffix}'
  params: {
    location: vLocation
    vmName: VMName
    authenticationType: 'sshPublicKey'
    adminPasswordOrKey: vKeyString
    virtualNetworkName: vVNetName
    subnetName: 'subnet1'
    networkSecurityGroupName: vNSGName
    ubuntuOSVersion: '16.04.0-LTS' 
    vmSize: 'Standard_B2s' 
    dataDiskName: diskName
  }
  dependsOn: [
    stgDisk
  ]  
}

