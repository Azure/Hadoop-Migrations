@description('Specifies the location of all deployed resources.')
param location string = resourceGroup().location

@description('Specifies the Cosmos DB account name (max length 44 characters).')
param cosmosAccountName string

@description('Specifies the resource id of the key vault to store the storage access key.')
param keyVaultId string

@description('Specifies the id of the subnet which the private endpoint uses.')
param subnetId string

@description('Specifies the ID of the private dns zone.')
param privateDnsZoneId string

var location_var = location
var cosmosAccountName_var = cosmosAccountName

var keyVaultId_var = keyVaultId
var keyVaultName = last(split(keyVaultId_var, '/'))
var subnetId_var = subnetId
var privateDnsZoneId_var = privateDnsZoneId
var privateEndpointName_var = '${cosmosAccountName_var}-private-endpoint'

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
      id: subnetId_var
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
          privateDnsZoneId: privateDnsZoneId_var
        }
      }
    ]
  }
}

