@description('Specifies the location of all deployed resources.')
param location string = resourceGroup().location

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
@secure()
param sqlAdministratorLoginPassword string

@allowed([
  'Small'
  'Medium'
  'Large'
])
@description('This parameter will determine the node size if SparkDeployment is true')
param sparkNodeSize string = 'Medium'

//@description('Specifies the name of the Azure Active Directory group of the SQL admin group.')
//param synapseSqlAdminGroupName string

//@description('Specifies the Azure Active Directory objectID of the SQL admin group.')
//param synapseSqlAdminGroupObjectID string

@description('Specifies the name of the subnet which the private endpoint uses.')
param vnetName string

@description('Specifies the name of the subnet which the private endpoint uses.')
param subnetName string

@description('Specifies the name of the private dns zone for sql pools.')
param privateDnsZoneNameSql string

@description('Specifies the name of the private dns zone for dev.')
param privateDnsZoneNameDev string

var subnetId = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
var privateDnsZoneIdSql = resourceId('Microsoft.Network/privateDnsZones', privateDnsZoneNameSql) 
var privateDnsZoneIdDev = resourceId('Microsoft.Network/privateDnsZones', privateDnsZoneNameDev) 

var subnetId_var = subnetId
var privateDnsZoneIdSql_var = privateDnsZoneIdSql
var privateDnsZoneIdDev_var = privateDnsZoneIdDev
var privateEndpointNameSql_var = '${workspaceName}-sql-pe'
var privateEndpointNameSqlOnDemand_var = '${workspaceName}-sqlondemand-pe'
var privateEndpointNameDev_var = '${workspaceName}-dev-pe'
//var synapseSqlAdminGroupName_var = synapseSqlAdminGroupName
//var synapseSqlAdminGroupObjectID_var = synapseSqlAdminGroupObjectID

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

    //adlaResourceId: synapseDatalakeAnalyticsResourceId_var
    //virtualNetworkProfile: {
    //  computeSubnetId: synapseComputeSubnetResourceId_var
    //}
    managedResourceGroupName: workspaceName
    managedVirtualNetworkSettings: {
      allowedAadTenantIdsForLinking: [
        subscription().tenantId
      ]
      linkedAccessCheckOnTargetResource: true
      preventDataExfiltration: true
    }
    connectivityEndpoints: {}
    //purviewConfiguration: {
    //  purviewResourceId: purviewId_var
    //}
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

//resource synapseWorkspaceName_activeDirectory 'Microsoft.Synapse/workspaces/administrators@2019-06-01-preview' = if ((!empty(synapseSqlAdminGroupName_var)) && (!empty(synapseSqlAdminGroupObjectID_var))) {
//  name: '${workspaceName_rcs.name}/activeDirectory'
//  properties: {
//    administratorType: 'ActiveDirectory'
//    login: synapseSqlAdminGroupName_var
//    sid: synapseSqlAdminGroupObjectID_var
//    tenantId: subscription().tenantId
//  }
//}

resource privateEndpointNameSql 'Microsoft.Network/privateEndpoints@2020-05-01' = {
  name: privateEndpointNameSql_var
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointNameSql_var
        properties: {
          privateLinkServiceId: workspaceName_rcs.id
          groupIds: [
            'Sql'
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

resource privateEndpointNameSql_aRecord 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-05-01' = {
  name: '${privateEndpointNameSql.name}/aRecord'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: '${privateEndpointNameSql_var}-aRecord'
        properties: {
          privateDnsZoneId: privateDnsZoneIdSql_var
        }
      }
    ]
  }
}

resource privateEndpointNameSqlOnDemand 'Microsoft.Network/privateEndpoints@2020-05-01' = {
  name: privateEndpointNameSqlOnDemand_var
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointNameSqlOnDemand_var
        properties: {
          privateLinkServiceId: workspaceName_rcs.id
          groupIds: [
            'SqlOnDemand'
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

resource privateEndpointNameSqlOnDemand_aRecord 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-05-01' = {
  name: '${privateEndpointNameSqlOnDemand.name}/aRecord'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: '${privateEndpointNameSqlOnDemand_var}-aRecord'
        properties: {
          privateDnsZoneId: privateDnsZoneIdSql_var
        }
      }
    ]
  }
}

resource privateEndpointNameDev 'Microsoft.Network/privateEndpoints@2020-05-01' = {
  name: privateEndpointNameDev_var
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointNameDev_var
        properties: {
          privateLinkServiceId: workspaceName_rcs.id
          groupIds: [
            'Dev'
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

resource privateEndpointNameDev_aRecord 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-05-01' = {
  name: '${privateEndpointNameDev.name}/aRecord'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: '${privateEndpointNameDev_var}-aRecord'
        properties: {
          privateDnsZoneId: privateDnsZoneIdDev_var
        }
      }
    ]
  }
}  