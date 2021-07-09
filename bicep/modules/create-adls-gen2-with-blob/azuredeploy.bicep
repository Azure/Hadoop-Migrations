@description('Location for the resources')
param location string = resourceGroup().location

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

@description('Specifies the name of default blob container')
param containerName string = 'blob01'  

@description('Specifies the name of default file service')
param fileServiceName string = 'file01'  

@description('Specifies the name of default queue service')
param queueServiceName string = 'queue01'  

@description('Specifies the name of default table service')
param tableServiceName string = 'table01'  

resource storageAccountName_rcs 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
        table: {
          enabled: true
        }
        queue: {
          enabled: true
        }
      }
    }
    isHnsEnabled: true
    supportsHttpsTrafficOnly: true
  }
}

resource storageAccountName_default_containerName 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAccountName}/default/${containerName}'
  dependsOn: [
    storageAccountName_rcs
  ]
}

resource storageAccountName_default_fileServiceName 'Microsoft.Storage/storageAccounts/fileServices/shares@2019-06-01' = {
  name: '${storageAccountName}/default/${fileServiceName}'
  dependsOn: [
    storageAccountName_rcs
  ]
}

resource storageAccountName_default_queueServiceName 'Microsoft.Storage/storageAccounts/queueServices/queues@2019-06-01' = {
  name: '${storageAccountName}/default/${queueServiceName}'
  dependsOn: [
    storageAccountName_rcs
  ]
}

resource storageAccountName_default_tableServiceName 'Microsoft.Storage/storageAccounts/tableServices/tables@2019-06-01' = {
  name: '${storageAccountName}/default/${tableServiceName}'
  dependsOn: [
    storageAccountName_rcs
  ]
}

output outputmessage string = '${storageAccountName} creation done successfully'