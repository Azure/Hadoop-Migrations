@description('Location for your data factory')
param location string = resourceGroup().location

@description('Name of the instance')
param dataFactoryName string = 'myv2datafactory'

resource dataFactoryName_resource 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}