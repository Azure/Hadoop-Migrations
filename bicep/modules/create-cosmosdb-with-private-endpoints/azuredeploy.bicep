@description('Specifies the location of all deployed resources.')
param location string = resourceGroup().location

@description('Specifies the Cosmos DB account name (max length 44 characters).')
param cosmosAccountName string = 'hdmp001csms001'

@description('Specifies the resource id of the key vault to store the storage access key.')
param keyVaultName string = 'hdmp001kv001'

@description('Specifies the name of the VNet which the private endpoint uses.')
param vnetName string = 'vnetBlue'

@description('Specifies the name of the subnet which the private endpoint uses.')
param subnetName string = 'subnet1'

@description('Specifies the name of the private dns zone.')
param privateDnsZoneName string = 'hdmp001-pdns.com'

//var keyVaultId = resourceId('Microsoft.KeyVault/vaults', keyVaultName)
var subnetId = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
var privateDnsZoneId = resourceId('Microsoft.Network/privateDnsZones', privateDnsZoneName)

var location_var = location
var cosmosAccountName_var = cosmosAccountName
var privateEndpointName_var = '${cosmosAccountName_var}-pe'

resource cosmosAccountName_resource 'Microsoft.DocumentDB/databaseAccounts@2020-06-01-preview' = {
  name: cosmosAccountName_var
  kind: 'GlobalDocumentDB'
  location: location_var
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'BoundedStaleness'
      maxIntervalInSeconds: 10
      maxStalenessPrefix: 200
    }
    locations: [
      {
        locationName: location_var
        failoverPriority: 0
        isZoneRedundant: true
      }
    ]
    databaseAccountOfferType: 'Standard'
    ipRules: []
    isVirtualNetworkFilterEnabled: true
    enableAutomaticFailover: true
    virtualNetworkRules: []
    enableMultipleWriteLocations: false
    enableCassandraConnector: false
    publicNetworkAccess: 'Disabled'
    capabilities: []
    disableKeyBasedMetadataWriteAccess: true
    enableAnalyticalStorage: false
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
        backupIntervalInMinutes: 240
        backupRetentionIntervalInHours: 8
      }
    }
    cors: []
    createMode: 'Default'
  }
}

resource privateEndpointName 'Microsoft.Network/privateEndpoints@2020-05-01' = {
  name: privateEndpointName_var
  location: location_var
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointName_var
        properties: {
          privateLinkServiceId: cosmosAccountName_resource.id
          groupIds: [
            'sql'
          ]
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: subnetId
    }
  }
}

resource keyVaultName_cosmosConnectionString 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyVaultName}/cosmosConnectionString'
  properties: {
    contentType: 'text/plain'
    value: listConnectionStrings(cosmosAccountName_resource.id, '2020-04-01').connectionStrings[0].connectionString
    attributes: {
      enabled: true
    }
  }
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

