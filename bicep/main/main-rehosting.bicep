//// Parameters

@description('Location to create all resources')
param location string = resourceGroup().location

@description('Project name')
param projectName string = 'hdmp001'

//// Variables

var vLocation = location
var vProjectName = projectName

var vVNetName = '${vProjectName}vnet001'
var vNSGName = '${vProjectName}nsg001'

// VNET Creation
module stgVNET '../modules/create-vnet-with-nsg/azuredeploy.bicep' = {
  name: 'create-vnet-and-nsg'
  params: {
    location: vLocation
    VNetName: vVNetName
    addressSpacePrefix: '10.0.0.0/16'
    subnet1Name: 'subnet1'
    subnet1Prefix: '10.0.1.0/24'
    subnet2Name: 'subnet2'
    subnet2Prefix: '10.0.2.0/24'
    subnet3Name: 'subnet3'
    subnet3Prefix: '10.0.3.0/24'
    networkSecurityGroupName: vNSGName
  }
}

resource sshKeyName_resource 'Microsoft.Compute/sshPublicKeys@2020-12-01' existing = {
  name: 'DEFAULT01'
}

//@batchSize(1)
module stgHeads 'main-rehosting-typevm1.bicep' = [for i in range(0,3): {
  name: 'create-head-node${i}'
  params: {
    location: vLocation
    projectName: vProjectName
    keyString: sshKeyName_resource.properties.publicKey 
    identifier: i
    suffix: 'head${i}'
  }
}]

//@batchSize(1)
module stgWorkers 'main-rehosting-typevm1.bicep' = [for i in range(0,2): {
  name: 'create-worker-node${i}'
  params: {
    location: vLocation
    projectName: vProjectName
    keyString: sshKeyName_resource.properties.publicKey 
    identifier: i
    suffix: 'wrkr${i}'
  }
  //dependsOn: [
  //  stgHeads
  //]
}]



