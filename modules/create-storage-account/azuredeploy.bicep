@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
  'Premium_LRS'
])
@description('Storage Account type')
param storageAccountType string = 'Standard_LRS'

@description('Storage Account name')
param storageAccountName string = 'sa001'

@description('Location for all resources.')
param location string = resourceGroup().location

resource storageAccountName_rcs 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {}
}

output outputmessage string = '${storageAccountName} creation done successfully'