//// Parameters

@description('Location to create all resources')
param location string = resourceGroup().location

@description('Project name')
param projectName string = 'hdmp001'

@description('ObjectID of managed app')
param objectId string

@description('TenantID of current subscription')
param tenantId string = subscription().tenantId

@allowed([
  'standard'
  'premium'
])
@description('Specifies whether the key vault is a standard vault or a premium vault.')
param skuName string = 'standard'

@description('Specifies the name of the secret that you want to create.')
param secretName string = 'sec01'

@description('Specifies the value of the secret that you want to create.')
@secure()
param secretValue string = newGuid()

//// Variables

var vLocation = location
var vProjectName = projectName
var vObjectId = objectId
var vTenantId = tenantId
var vSKUName = skuName
var vSecretName = secretName
var vSecretValue = secretValue

var vKeyVaultName = '${vProjectName}kv001'
var vVNetBlueName = 'vnetBlue'
var vPrivateDnsZoneName = '${vProjectName}-pdns.com'

//// Stages

// Key Valut Creation 
module stgKV '../modules/create-key-vault-with-private-endpoints/azuredeploy.bicep' = {
  name: 'create-key-vault'
  params: {
    location: vLocation
    keyVaultName: vKeyVaultName
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    objectId: vObjectId
    tenantId: vTenantId
    keysPermissions: array('all')
    secretsPermissions: array('all')
    skuName: vSKUName
    secretName: vSecretName
    secretValue: vSecretValue
    vnetName: vVNetBlueName
    subnetName: 'subnet1'
    privateDnsZoneName: vPrivateDnsZoneName
  }
  dependsOn: [
  ]
}
