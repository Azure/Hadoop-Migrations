@description('A new GUID used to identify the role assignment')
param roleNameGuid string = newGuid()

@description('User Assigned Identity name to create and assign Storage Blob Data Owner role to')
param userAssignedIdentityName string

@description('Strong Account Name to assign Storage Blob Data Owner role')
param clusterStorageAccountName string

var roleStorageBlobDataOwner = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b7e6dc6d-f1e8-4753-8033-0f276bb0955b'

resource userAssignedIdentityName_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: userAssignedIdentityName
}

resource storageName 'Microsoft.Storage/storageAccounts@2019-04-01' existing = {
  name: clusterStorageAccountName
}

resource roleNameGuid_resource 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: roleNameGuid
  properties: {
    roleDefinitionId: roleStorageBlobDataOwner
    principalId: userAssignedIdentityName_resource.properties.principalId
  }
  scope: storageName
  dependsOn: [
    storageName
  ]
}