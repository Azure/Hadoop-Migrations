@description('Location to create all resources')
param glocation string = 'koreacentral'

@description('Project name')
param gprojectName string = 'hdmp001'

var vnetMgmtName = 'vnet-krc-010'
var vnetBlueName = 'vnet-krc-011'
var nsgName = 'nsg-krc-011'
var saName = 'sakrc011'
var privateDnsZoneName = 'euphoria.com'

param publicKey string = 'ssh-rsa ****'

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
      privateEndpointNetworkPolicies: 'Disabled'
    }
    vNet2Name: vnetBlueName
    vNet2Config: {
      addressSpacePrefix: '192.168.14.0/23'
      subnetName: 'subnet1'
      subnetPrefix: '192.168.14.0/26'
      privateEndpointNetworkPolicies: 'Disabled'
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
// Storage Account Creation, ADLS Gen2 with a Blob container
module stgSA './modules/create-adls-gen2-with-blob/azuredeploy.bicep' = {
  name: 'create-storage-account'
  params: {
    location: glocation
    storageAccountType: 'Standard_LRS'
    storageAccountName: saName
    containerName: 'blob1'
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
    projectName: gprojectName
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

/*
// Key Valut Creation .... can't access from portal
module stgKV './modules/create-key-vault/azuredeploy.bicep' = {
  name: 'create-key-vault'
  params: {
    location: glocation
    keyVaultName: 'kv-krc-502'
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    objectId: 'ec847c95-e7b1-4f60-89dc-0abe8c01949f'
    tenantId: '72f988bf-86f1-41af-91ab-2d7cd011db47'
    keysPermissions: array('all')
    secretsPermissions: array('all')
    skuName: 'premium'
    secretName: 'sec-01'
    secretValue: 'sec-value-string'
 }
}
*/

/*
// Managed Identity Creation assigning Blob Storage Ownder role to the Storage Account
// Step 1
var userAssignedIdentityName = 'uain-007'

//resource userAssignedIdentityName_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
//  name: userAssignedIdentityName
//  location: glocation
//}

// Step 2
module stgUAI './modules/assign-userassignedidentity/azuredeploy.bicep' = {
  name: 'assign-userassignedidentity-to-storage'
  params: {
     userAssignedIdentityName: userAssignedIdentityName
     clusterStorageAccountName: concat('sakrc002', gprojectName)
 }
}
*/

// HDI Cluster Creation,.. has to be separated into 2 steps, 1 sa + user assigned identity/role ssignment (manually) 2 cluster creation
module stgKV './modules/create-hdinsight-datalake-store-azure-storage/azuredeploy.bicep' = {
  name: 'create-hdinsight'
  params: {
    location: glocation
    // "'hadoop' | 'hbase' | 'spark' | 'interactivehive'" //'storm' is not supported in 4.0
    clusterType: 'hadoop'
    clusterName: concat('hdi-krc-003-', gprojectName)
    clusterLoginUserName: 'hdmpuser'
    clusterLoginPassword: 'H$ngh9731@'
    sshUserName: 'azureuser'
    sshPassword: 'H$ngh9731@'
    clusterStorageAccountName: concat('sakrc003', gprojectName)
    userAssignedIdentityName: 'uain-007'
    vmSizeHeadNode: 'Standard_E8_v3'
    vmSizeWorkerNode: 'Standard_A5'
    vmSizeZookeeperNode: 'Standard_A5'
 }
}

/*
// Synapse with Spark pool
module stgSNPS './modules/create-synapse-workspace/azuredeploy.bicep' = {
  name: 'create-synapse-with-sparkpool'
  params: {
    location: glocation
    projectName: gprojectName
    workspaceName: concat('snps-krc-002-', gprojectName)
    sparkPoolName: 'spp01'
    sqlPoolName: 'sqp01'
    dataLakeStorageAccountName: 'sakrc002hdmp001'
    dataLakeStorageFieshareName: 'file01'
    sqlAdministratorLogin: 'hdmpuser'
    sqlAdministratorLoginPassword: 'H$ngh9731@'
 }
}
*/

/*
// ADB with Load Balancer
module stgADB './modules/create-databricks/azuredeploy.bicep' = {
  name: 'create-databricks-with-loadbalancer'
  params: {
    location: glocation
    workspaceName: concat('adb-krc-001-', gprojectName)
    pricingTier: 'premium'
    nsgName: nsgName
    disablePublicIp: false 
    vnetADBName: 'vnet-krc-012-adb'
    vnetADBCider: '192.168.16.0/23'
    publicSubnetName: 'sub1-adb-pub'
    publicSubnetCidr: '192.168.16.0/26'
    privateSubnetName: 'sub2-adb-prv'
    privateSubnetCidr: '192.168.16.64/26'
    loadBalancerPublicIpName: 'ip-krc-001-adblb'
    loadBalancerName: 'lb-krc-001-adblb'
    loadBalancerFrontendConfigName: 'lbfe-cfg-krc-001-adblb'
    loadBalancerBackendPoolName: 'lbbep-name-krc-001-adblb'
 }
}
*/

/*
// Data Factory instance creation
module stgADB './modules/create-datafactory/azuredeploy.bicep' = {
  name: 'create-datafactory'
  params: {
    location: glocation
    dataFactoryName: 'adf-krc-001'
 }
}
*/

/*
//Cosmos instance creation with privte endpoints

var privateEndpointName_var = 'pep002'

resource keyVaultName_resource 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: 'kv-krc-502'
}

resource privateDnsZoneName_resource 'Microsoft.Network/privateDnsZones@2020-01-01' existing = {
  name: 'euphoria.com'
}

resource vNet2Name_resource 'Microsoft.Network/virtualNetworks@2020-05-01' existing = {
  name: 'vnet-krc-211'
}

module stgADB './modules/create-cosmosdb-with-private-endpoints/azuredeploy.bicep' = {
  name: 'create-cosmosdb-with-private-endpoints'
  params: {
    location: glocation
    cosmosAccountName: 'csms-krc-001'
    subnetId: vNet2Name_resource.properties.subnets[0].id
    privateDnsZoneId: privateDnsZoneName_resource.id
    keyVaultId: keyVaultName_resource.id
  }
}
*/