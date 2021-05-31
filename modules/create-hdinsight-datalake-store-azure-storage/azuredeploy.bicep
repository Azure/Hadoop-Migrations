@description('Specifies the Azure location where the key vault should be created.')
param location string = resourceGroup().location 

//  storm is not supported in 4.0
@allowed([
  'hadoop'
  'hbase'
  'spark'
  'interactivehive'
])
@description('The type of the HDInsight cluster to create.')
param clusterType string

@description('The name of the HDInsight cluster to create.')
param clusterName string

@description('These credentials can be used to submit jobs to the cluster and to log into cluster dashboards.')
param clusterLoginUserName string

@description('The password must be at least 10 characters in length and must contain at least one digit, one non-alphanumeric character, and one upper or lower case letter.')
@secure()
param clusterLoginPassword string

@description('These credentials can be used to remotely access the cluster.')
param sshUserName string

@description('The password must be at least 10 characters in length and must contain at least one digit, one non-alphanumeric character, and one upper or lower case letter.')
@secure()
param sshPassword string

@description('The name of the Azure storage account to be created and be used as the cluster\'s primary storage.')
param clusterStorageAccountName string

@description('The number of nodes in the HDInsight cluster.')
param clusterWorkerNodeCount int = 4

@description('The number of head nodes in the HDInsight cluster.')
param clusterHeadNodeCount int = 2

@description('The number of Zookeeper nodes in the HDInsight cluster.')
param clusterZookeeperNodeCount int = 3

@description('The number of Zookeeper nodes in the HDInsight cluster.')
param userAssignedIdentityName string = 'uain-001'

@description('VM Spec for Head Node')
param vmSizeHeadNode string = 'Standard_D3'

@description('VM Spec for Worker Node')
param vmSizeWorkerNode string = 'Standard_D3'

@description('VM Spec for ZooKeeper Node')
param vmSizeZookeeperNode string = 'Standard_D3'

resource clusterStorageAccountName_resource 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: clusterStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
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
      }
    }
    accessTier: 'Hot' 
    isHnsEnabled: true
    supportsHttpsTrafficOnly: true
  }
}

resource clusterStorageAccountName_default_containerName 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${clusterStorageAccountName}/default/blob01'
  dependsOn: [
    clusterStorageAccountName_resource
  ]
}

resource clusterStorageAccountName_default_shareName 'Microsoft.Storage/storageAccounts/fileServices/shares@2019-06-01' = {
  name: '${clusterStorageAccountName}/default/file01'
  dependsOn: [
    clusterStorageAccountName_resource
  ]
}

var managedIdentityId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${userAssignedIdentityName}'

resource userAssignedIdentityName_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userAssignedIdentityName
  location: location
}

resource clusterName_resource 'Microsoft.HDInsight/clusters@2018-06-01-preview' = {
  name: clusterName
  location: location
  properties: {
    clusterVersion: '4.0'
    osType: 'Linux'
    tier: 'Standard'
    clusterDefinition: {
      kind: clusterType
      configurations: {
        gateway: {
          'restAuthCredential.isEnabled': true
          'restAuthCredential.username': clusterLoginUserName
          'restAuthCredential.password': clusterLoginPassword
        }
      }
    }
    storageProfile: {
      storageaccounts: [
        {
          name: '${clusterStorageAccountName}.dfs.core.windows.net'
          isDefault: true
          fileSystem: 'file01'
          key: listKeys(clusterStorageAccountName_resource.id, '2019-06-01').keys[0].value
          resourceId: clusterStorageAccountName_resource.id
          msiResourceId: managedIdentityId
        }
      ]
    }
    computeProfile: {
      roles: [
        {
          name: 'headnode'
          targetInstanceCount: clusterHeadNodeCount
          hardwareProfile: {
            vmSize: vmSizeHeadNode
          }
          osProfile: {
            linuxOperatingSystemProfile: {
              username: sshUserName
              password: sshPassword
            }
          }
        }
        {
          name: 'workernode'
          targetInstanceCount: clusterWorkerNodeCount
          hardwareProfile: {
            vmSize: vmSizeWorkerNode
          }
          osProfile: {
            linuxOperatingSystemProfile: {
              username: sshUserName
              password: sshPassword
            }
          }
        }
        {
          name: 'zookeepernode'
          targetInstanceCount: clusterZookeeperNodeCount
          hardwareProfile: {
            vmSize: vmSizeZookeeperNode
          }
          osProfile: {
            linuxOperatingSystemProfile: {
              username: sshUserName
              password: sshPassword
            }
          }
        }        
      ]
    }
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityId}': {}
    }
  }    
}
