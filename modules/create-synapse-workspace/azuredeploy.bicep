@description('Location to create all resources')
param location string = 'koreacentral'

@description('Project name')
param projectName string = 'hdmp001'

@description('Select the SKU of the SQL pool.')
param skuSQLPool string = 'DW100c'

@description('Choose whether you want to synchronise metadata.')
param metadataSync bool = false

@allowed([
  'true'
  'false'
])
@description('Fire wall setting, whether to allow from all connections')
param allowAllConnections string = 'true'

@allowed([
  'true'
  'false'
])
@description('\'True\' deploys an Apache Spark pool as well as a SQL pool. \'False\' does not deploy an Apache Spark pool.')
param sparkDeployment string = 'true'

@description('Workspace name of Synapse instance')
param workspaceName string = projectName

@description('Spark Pool name of workspace')
param sparkPoolName string = toLower('spp01')

@description('SQL Pool name of workspace')
param sqlPoolName string = toLower('sqp01')

@description('Datalake Storage Account name for this workspace')
param dataLakeStorageAccountName string

@description('Datalake Storage Account File Share name for this workspace')
param dataLakeStorageFieshareName string

@description('SQL user name')
param sqlAdministratorLogin string

@description('SQL user password')
param sqlAdministratorLoginPassword string

@allowed([
  'Small'
  'Medium'
  'Large'
])
@description('This parameter will determine the node size if SparkDeployment is true')
param sparkNodeSize string = 'Medium'

resource dataLakeStorageAccountName_rcs 'Microsoft.Storage/storageAccounts@2019-04-01' existing = {
  name: dataLakeStorageAccountName
}

//resource workspaceName_rcs 'Microsoft.Synapse/workspaces@2019-06-01-preview' existing = {
//  name: workspaceName
//}

resource workspaceName_rcs 'Microsoft.Synapse/workspaces@2019-06-01-preview' = {
  name: workspaceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      //accountUrl: reference(dataLakeStorageAccountName).primaryEndpoints.dfs
      accountUrl: 'https://${dataLakeStorageAccountName}.dfs.core.windows.net/'
      //accountUrl: dataLakeStorageAccountName_rcs.primaryEndpoints.dfs
      filesystem: dataLakeStorageFieshareName
    }
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorLoginPassword: sqlAdministratorLoginPassword
    managedVirtualNetwork: 'default'
  }
  dependsOn: [
    //dlsName_var
    //dlsName_default_dlsFsName
  ]
}

resource workspaceName_allowAll 'Microsoft.Synapse/workspaces/firewallrules@2019-06-01-preview' = if (allowAllConnections == 'true') {
  name: '${workspaceName_rcs.name}/allowAll'
  //location: location
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

resource workspaceName_AllowAllWindowsAzureIps 'Microsoft.Synapse/workspaces/firewallrules@2019-06-01-preview' = {
  name: '${workspaceName_rcs.name}/AllowAllWindowsAzureIps'
  //location: location
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource workspaceName_default 'Microsoft.Synapse/workspaces/managedIdentitySqlControlSettings@2019-06-01-preview' = {
  name: '${workspaceName_rcs.name}/default'
  //location: location
  properties: {
    grantSqlControlToManagedIdentity: {
      desiredState: 'Enabled'
    }
  }
} 

resource workspaceName_sqlPoolName_rcs 'Microsoft.Synapse/workspaces/sqlPools@2019-06-01-preview' = {
  name: '${workspaceName_rcs.name}/${sqlPoolName}'
  location: location
  sku: {
    name: skuSQLPool
  }
  properties: {
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
  }
}

resource workspaceName_sqlPoolName_config 'Microsoft.Synapse/workspaces/sqlPools/metadataSync@2019-06-01-preview' = if (metadataSync) {
  name: '${workspaceName_sqlPoolName_rcs.name}/config'
  //location: location
  properties: {
    enabled: metadataSync
  }
}

resource workspaceName_sparkPoolName 'Microsoft.Synapse/workspaces/bigDataPools@2019-06-01-preview' = if (sparkDeployment == 'true') {
  name: '${workspaceName_rcs.name}/${sparkPoolName}'
  location: location
  properties: {
    nodeCount: 5
    nodeSizeFamily: 'MemoryOptimized'
    nodeSize: sparkNodeSize
    autoScale: {
      enabled: true
      minNodeCount: 3
      maxNodeCount: 40
    }
    autoPause: {
      enabled: true
      delayInMinutes: 15
    }
    sparkVersion: '2.4'
  }
} 