//// Parameters

@description('Location to create all resources')
param location string = resourceGroup().location

@description('Project name')
param projectName string = 'hdmp001'

// Parameters - Options to provision

@allowed([
  true
  false
])
@description('Prompt to ask if HDInsight cluster creation needed')
param optHDInsightCreation bool = true

@allowed([
  true
  false
])
@description('Prompt to ask if Cosmos DB creation needed')
param optCosmosDBCreation bool = true

@allowed([
  true
  false
])
@description('Prompt to ask if Synapse Workspace creation needed')
param optSynapseCreation bool = true

@allowed([
  true
  false
])
@description('Prompt to ask if Azure Databrick creation needed')
param optDataBrickCreation bool = true

@allowed([
  true
  false
])
@description('Prompt to ask if Data Factory creation needed')
param optDataFactoryCreation bool = true

// Parameters - HDI

@allowed([
  'hadoop'
  'hbase'
  'spark'
  'interactivehive'
]) 
@description('Type of HDI Cluster. storm is not supported in 4.0')
param hdiClusterType string = 'hadoop'

@description('Login user name of the HDI cluster')
param hdiLoginUserName string = 'hdmpuser'

@description('Login user password of the HDI cluster')
@secure()
param hdiLoginPassword string = 'H$ngh9731@' //newGuid()

@description('Login user name of the HDI cluster VMs')
param hdiSSHUserName string = 'azureuser'

@description('Login user password of the HDI cluster VMs')
@secure()
param hdiSSHPassword string = 'H$ngh9731@' //newGuid()

@description('VM size of head nodes of the HDI cluster')
param hdiVMSizeHeads string = 'Standard_E8_v3'

@description('VM size of worker nodes of the HDI cluster')
param hdiVMSizeWorker string = 'Standard_A5'

@description('VM size of ZooKeeper nodes of the HDI cluster')
param hdiVMSizeZookeeper string = 'Standard_A5'

// Parameters - Synapse

//param snpsWorkspaceName string = '${vProjectName}snps001'
//param snpsSparkPoolName string = '${vProjectName}spp001'
//param snpsSQLPoolName string = '${vProjectName}sqp001'
//param snpsDataLakeStorageAccountName string = vSAName
//param snpsDataLakeStorageFieshareName string = 'file01'

@description('Login user name of Synapse SQL')
param snpsSQLAdmUserName string = 'hdmpuser'

@description('Login user password of Synapse SQL')
@secure()
param snpsSQLAdmPassword string = 'H$ngh9731@' //newGuid()

// Parameters - CosmosDB

// Parameters - DataBrick

// Parameters - Data Factory

//// Variables

var vLocation = location
var vProjectName = projectName

var vKeyVaultName = '${vProjectName}kv001'
var vVNetBlueName = 'vnetBlue'
var vPrivateDnsZoneName = '${vProjectName}-pdns.com'
var vUserAssignedIdentityName = '${vProjectName}uain001'
var vNSGName = '${vProjectName}nsg001'
var vSAName = '${vProjectName}sa001'

var vHDIClusterName = '${vProjectName}hdi001'
var vHDIClusterType = hdiClusterType
var vHDILoginUserName = hdiLoginUserName
var vHDILoginPassword = hdiLoginPassword
var vHDISSHUserName = hdiSSHUserName
var vHDISSHPassword = hdiSSHPassword
var vHDIVMSizeHeads = hdiVMSizeHeads
var vHDIVMSizeWorker = hdiVMSizeWorker
var vHDIVMSizeZookeeper = hdiVMSizeZookeeper
var vHDISubnetName = 'subnet-hdi'
var vHDISubnetCidr = '192.168.13.192/26'

var vSNPSWorkspaceName = '${vProjectName}snps001' // snpsWorkspaceName
var vSNPSSparkPoolName = '${vProjectName}spp001' // snpsSparkPoolName
var vSNPSSQLPoolName = '${vProjectName}sqp001' // snpsSQLPoolName
var vSNPSDataLakeStorageAccountName = vSAName // snpsDataLakeStorageAccountName
var vSNPSDataLakeStorageFieshareName = 'file01' // snpsDataLakeStorageFieshareName
var vSNPSSQLAdmUserName = snpsSQLAdmUserName
var vSNPSSQLAdmPassword = snpsSQLAdmPassword

var vCSMSAccountName = '${vProjectName}csms001'
var vADFName = '${vProjectName}adf001'

var vADBWorkspaceName = '${vProjectName}adb001'
var vADBPricingTier = 'premium'
//var vADBVNetName = '${vADBWorkspaceName}vnet-adb'
var vADBVNetName = vVNetBlueName
//var vADBVNetCider = '192.168.16.0/23'
var vADBVSubnetPubName = 'subnet-adb-pub'
var vADBVSubnetPubCider = '192.168.13.64/26'
var vADBVSubnetPvtName = 'subnet-adb-prv'
var vADBVSubnetPvtCider = '192.168.13.128/26'

//// Stages

resource privateDnsZoneName_resource 'Microsoft.Network/privateDnsZones@2020-01-01' existing = {
  name: vPrivateDnsZoneName
}

resource vnetBlueName_resource 'Microsoft.Network/virtualNetworks@2020-05-01' existing = {
  name: vVNetBlueName
}

resource keyVaultName_resource 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: vKeyVaultName
}

// HDI Cluster Creation
module stgHDI '../modules/create-hdinsight-datalake-store-azure-storage/azuredeploy.bicep' = if (optHDInsightCreation) {
  name: 'create-hdinsight'
  params: {
    location: vLocation
    // "'hadoop' | 'hbase' | 'spark' | 'interactivehive'" //'storm' is not supported in 4.0
    clusterType: vHDIClusterType
    clusterName: vHDIClusterName
    clusterLoginUserName: vHDILoginUserName
    clusterLoginPassword: vHDILoginPassword
    sshUserName: vHDISSHUserName
    sshPassword: vHDISSHPassword
    clusterStorageAccountName: vSAName
    userAssignedIdentityName: vUserAssignedIdentityName
    vmSizeHeadNode: vHDIVMSizeHeads
    vmSizeWorkerNode: vHDIVMSizeWorker
    vmSizeZookeeperNode: vHDIVMSizeZookeeper
    vnetHDIName: vVNetBlueName
    hdiSubnetName: vHDISubnetName
    hdiSubnetCidr: vHDISubnetCidr
 }
}

//Cosmos instance creation with privte endpoints
module stgCSMS '../modules/create-cosmosdb-with-private-endpoints/azuredeploy.bicep' = if (optCosmosDBCreation) {
  name: 'create-cosmosdb-with-private-endpoints'
  params: {
    location: vLocation
    cosmosAccountName: vCSMSAccountName
    keyVaultName: vKeyVaultName
    vnetName: vVNetBlueName
    subnetName: vnetBlueName_resource.properties.subnets[0].name
    privateDnsZoneName: vPrivateDnsZoneName
  }
}

// ADB with Load Balancer
module stgADB '../modules/create-databricks-with-load-balancer/azuredeploy.bicep' = if (optDataBrickCreation) {
  name: 'create-databricks-with-loadbalancer'
  params: {
    location: vLocation
    workspaceName: vADBWorkspaceName
    pricingTier: vADBPricingTier
    nsgName: vNSGName
    disablePublicIp: true 
    vnetADBName: vADBVNetName
    //vnetADBCider: vADBVNetCider
    publicSubnetName: vADBVSubnetPubName
    publicSubnetCidr: vADBVSubnetPubCider
    privateSubnetName: vADBVSubnetPvtName
    privateSubnetCidr: vADBVSubnetPvtCider
    loadBalancerPublicIpName: '${vADBWorkspaceName}lb001-ip'
    loadBalancerName: '${vADBWorkspaceName}lb001'
    loadBalancerFrontendConfigName: '${vADBWorkspaceName}lb001-fec'
    loadBalancerBackendPoolName: '${vADBWorkspaceName}lb001-bep'
 }
}

// Synapse with Spark pool
module stgSNPS '../modules/create-synapse-workspace-with-private-endpoints/azuredeploy.bicep' = if (optSynapseCreation) {
  name: 'create-synapse-with-private-endpoints'
  params: {
    location: vLocation
    projectName: vProjectName
    workspaceName: vSNPSWorkspaceName
    sparkPoolName: vSNPSSparkPoolName
    sqlPoolName: vSNPSSQLPoolName
    dataLakeStorageAccountName: vSNPSDataLakeStorageAccountName
    dataLakeStorageFieshareName: vSNPSDataLakeStorageFieshareName
    sqlAdministratorLogin: vSNPSSQLAdmUserName
    sqlAdministratorLoginPassword: vSNPSSQLAdmPassword
    vnetName: vVNetBlueName
    subnetName: vnetBlueName_resource.properties.subnets[0].name
    privateDnsZoneNameSql: vPrivateDnsZoneName
    privateDnsZoneNameDev: vPrivateDnsZoneName
 }
}

// Data Factory instance creation
module stgADF '../modules/create-datafactory-with-private-endpoints/azuredeploy.bicep' = if (optDataFactoryCreation) {
  name: 'create-datafactory-with-private-endpoints'
  params: {
    location: vLocation
    dataFactoryName: vADFName
    keyVaultName: vKeyVaultName
    vnetName: vVNetBlueName
    subnetName: vnetBlueName_resource.properties.subnets[0].name
    privateDnsZoneNameDataFactory: vPrivateDnsZoneName
    privateDnsZoneNamePortal: vPrivateDnsZoneName    
 }
}