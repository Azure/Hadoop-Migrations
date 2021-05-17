@description('Location to create all resources')
param glocation string = 'koreacentral'

var vnetMgmtName = 'vnet-krc-010'
var vnetBlueName = 'vnet-krc-011'
var nsgName = 'nsg-krc-011'
var saName = 'sakrc011'
var privateDnsZoneName = 'euphoria.com'

param publicKey string = '<your public key>'

/*
// VNet Creation
module stgVM './modules/create-vnets-with-peering/azuredeploy.bicep' = {
  name: 'create-vnets'
  params: {
    location: glocation
    vNet1Name: vnetMgmtName
    vNet1Config: {
      addressSpacePrefix: '192.168.12.0/23'
      subnetName: 'subnet1'
      subnetPrefix: '192.168.12.0/26'
    }
    vNet2Name: vnetBlueName
    vNet2Config: {
      addressSpacePrefix: '192.168.14.0/23'
      subnetName: 'subnet1'
      subnetPrefix: '192.168.14.0/26'
    }
  }
}
*/

/*
// NSG Creation
module stgNSG './modules/create-nsg/azuredeploy.bicep' = {
  name: 'create-nsg'
  params: {
    location: glocation
    nsgName: nsgName
  }
}
*/

/*
// Storage Account Creation
module stgSA './modules/create-storage-account/azuredeploy.bicep' = {
  name: 'create-storage-account'
  params: {
    location: glocation
    storageAccountType: 'Standard_LRS'
    storageAccountName: saName
  }
}
*/

/*
// VM Creation for test nodes
module stgVMMgmt './modules/create-vm-simple-linux/azuredeploy.bicep' = {
  name: 'create-vm-mgmt'
  params: {
    location: glocation
    vmName: 'vm-krc-010'
    VmSize: 'Standard_B2s'
    virtualNetworkName: vnetMgmtName
    subnetName: 'subnet1'
    networkSecurityGroupName : nsgName
    adminUsername: 'azureuser'
    authenticationType: 'sshPublicKey'
    adminPasswordOrKey: publicKey
  }
}

module stVMBlue './modules/create-vm-simple-linux/azuredeploy.bicep' = {
  name: 'create-vm-blue'
  params: {
    location: glocation
    vmName: 'vm-krc-101'
    VmSize: 'Standard_B2s'
    virtualNetworkName: vnetBlueName
    subnetName: 'subnet1'
    networkSecurityGroupName : nsgName
    adminUsername: 'azureuser'
    authenticationType: 'sshPublicKey'
    adminPasswordOrKey: publicKey
  }
}
*/

/*
// Load Balancer Creation for test
module stgLB './modules/create-loadbalancer-http/azuredeploy.bicep' = {
  name: 'create-slb-http'
  params: {
    location: glocation
    projectName: 'hdmp001'
 }
}
*/

/*
// Private DNS Creation
module stgDNS './modules/create-private-dns-zone/azuredeploy.bicep' = {
  name: 'create-private-dns'
  params: {
    location: glocation
    privateDnsZoneName: privateDnsZoneName
    vnetName: vnetMgmtName
  }
}
*/

/*
// Private DNS Adding link
resource vnetBlueName_resource 'Microsoft.Network/virtualNetworks@2020-05-01' existing = {
  name: vnetBlueName
}

resource privateDnsZoneName_resource 'Microsoft.Network/privateDnsZones@2020-01-01' existing = {
  name: privateDnsZoneName
}

resource privateDnsZoneName_privateDnsZoneName_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-01-01' = {
  name: '${privateDnsZoneName_resource.name}/${privateDnsZoneName}-link2'
  location: 'global'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: vnetBlueName_resource.id
    }
  }
} 
*/

// Key Valut Creation 
module stgKV './modules/create-key-vault/azuredeploy.bicep' = {
  name: 'create-key-vault'
  params: {
    location: glocation
    keyVaultName: 'kv-krc-501'
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    objectId: 'ec847c95-e7b1-4f60-89dc-0abe8c01949f'
//    keysPermissions: ['all']
//    secretsPermissions: ['all']
    skuName: 'premium'
    //secretName: 
    //secretValue:    
 }
}