@description('Location of the resources')
param location string = resourceGroup().location

@description('Name of the resource')
param purviewName string

@description('Deployment environment')
param env string

resource purviewName_env 'Microsoft.Purview/accounts@2020-12-01-preview' = {
  name: '${purviewName}${env}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    networkAcls: {
      defaultAction: 'Allow'
    }
  }
  sku: {
    name: 'Standard'
    capacity: 4
  }
  tags: {}
  dependsOn: []
}