@description('Location of the resources')
param location string = resourceGroup().location

@description('Specifies the name of the key vault.')
param keyVaultName string

@allowed([
  true
  false
])
@description('Specifies whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault.')
param enabledForDeployment bool = false

@allowed([
  true
  false
])
@description('Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys.')
param enabledForDiskEncryption bool = false

@allowed([
  true
  false
])
@description('Specifies whether Azure Resource Manager is permitted to retrieve secrets from the key vault.')
param enabledForTemplateDeployment bool = false

@description('Specifies the Azure Entra ID tenant ID that should be used for authenticating requests to the key vault. Get it by using Get-AzSubscription cmdlet.')
param tenantId string = subscription().tenantId

@description('Specifies the object ID of a user, service principal or security group in the Azure Entra ID tenant for the vault. The object ID must be unique for the list of access policies. Get it by using Get-AzADUser or Get-AzADServicePrincipal cmdlets.')
param objectId string

@description('Specifies the permissions to keys in the vault. Valid values are: all, encrypt, decrypt, wrapKey, unwrapKey, sign, verify, get, list, create, update, import, delete, backup, restore, recover, and purge.')
param keysPermissions array = [
  'list'
]

@description('Specifies the permissions to secrets in the vault. Valid values are: all, get, list, set, delete, backup, restore, recover, and purge.')
param secretsPermissions array = [
  'list'
]

@allowed([
  'standard'
  'premium'
])
@description('Specifies whether the key vault is a standard vault or a premium vault.')
param skuName string = 'standard' 

@description('Specifies the name of the secret that you want to create.')
param secretName string

@description('Specifies the value of the secret that you want to create.')
@secure()
param secretValue string

@description('Private DNS Zone name')
param privateDnsZoneName string = 'consoto.com'

@description('VNet name')
param vnetName string = 'vNet'

@description('Subnet name of the VNet')
param subnetName string = 'subnet'

var subnetId = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
var privateDnsZoneId = resourceId('Microsoft.Network/privateDnsZones', privateDnsZoneName)

var privateEndpointName_var = '${keyVaultName}-pe'

resource keyVaultName_resource 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enablePurgeProtection: true
    enableSoftDelete: true
    enableRbacAuthorization: false
    createMode: 'default'
    tenantId: tenantId
    accessPolicies: [
      {
        objectId: objectId
        tenantId: tenantId
        permissions: {
          keys: keysPermissions
          secrets: secretsPermissions
        }
      }
    ]
    sku: {
      name: skuName
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

resource keyVaultName_secretName 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyVaultName_resource.name}/${secretName}'
  properties: {
    value: secretValue
  }
}

resource privateEndpointName 'Microsoft.Network/privateEndpoints@2020-05-01' = {
  name: privateEndpointName_var
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointName_var
        properties: {
          privateLinkServiceId: resourceId('Microsoft.KeyVault/vaults', keyVaultName)
          groupIds: [
            'vault'
          ]
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: subnetId
    }
  }
  dependsOn: [
    keyVaultName_resource
  ]
}

resource privateEndpointName_aRecord 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-05-01' = {
  name: '${privateEndpointName.name}/aRecord'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: '${privateEndpointName_var}-aRecord'
        properties: {
          privateDnsZoneId: privateDnsZoneId
        }
      }
    ]
  }
}
