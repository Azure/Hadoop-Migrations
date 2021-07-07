@description('Location for the resources')
param location string = resourceGroup().location

@description('The name of the Azure Databricks workspace to create.')
param workspaceName string = 'hdmp001adb001'

@description('The pricing tier of workspace.')
param pricingTier string = 'premium'

@description('Specifies whether to deploy Azure Databricks workspace with Secure Cluster Connectivity (No Public IP) enabled or not')
param disablePublicIp bool = true

@description('The name of the network security group to create.')
param nsgName string = 'hdmp001nsg001'

@description('The name of the virtual network to create.') 
param vnetADBName string = 'vnetBlue'

@description('The name of the public subnet to create.')
param publicSubnetName string = 'subnet-adb-pub'

@description('Cidr range for the public subnet..')
param publicSubnetCidr string = '192.168.13.64/26'

@description('The name of the private subnet to create.')
param privateSubnetName string = 'subnet-adb-prv'

@description('Cidr range for the private subnet.')
param privateSubnetCidr string = '192.168.13.128/26'

@description('Name of the outbound Load Balancer public IP.')
param loadBalancerPublicIpName string = 'ip-krc-001-adblb'

@description('Name of the outbound Load Balancer.')
param loadBalancerName string = 'lb-krc-001-adblb'

@description('Name of the outbound Load Balancer\'s Frontend Config.')
param loadBalancerFrontendConfigName string = 'lbfe-cfg-krc-001-adblb'

@description('Name of the outbound Load Balancer\'s Backend Pool.')
param loadBalancerBackendPoolName string = 'lbbep-name-krc-001-adblb'

var loadBalancerId = loadBalancerName_resource.id
var loadBalancerBackendPoolId = resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancerName, loadBalancerBackendPoolName)
var loadBalancerFrontendConfigId = resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', loadBalancerName, loadBalancerFrontendConfigName) 
var managedResourceGroupName = 'databricks-rg-${workspaceName}-${uniqueString(workspaceName, resourceGroup().id)}' 
var managedResourceGroupId = subscriptionResourceId('Microsoft.Resources/resourceGroups', managedResourceGroupName) 

resource nsgName_resource 'Microsoft.Network/networkSecurityGroups@2020-06-01' existing = {
  name: nsgName
}

resource vnetADBName_resource 'Microsoft.Network/virtualNetworks@2020-05-01' existing = {  
  name: vnetADBName
}

resource vnetADBName_pubSubnetName 'Microsoft.Network/virtualNetworks/subnets@2020-05-01' = {
  name: '${vnetADBName}/${publicSubnetName}'
  properties: {
    addressPrefix: publicSubnetCidr
    networkSecurityGroup: {
      id: nsgName_resource.id
    }
    delegations: [
      {
        name: 'databricks-del-public'
        properties: {
          serviceName: 'Microsoft.Databricks/workspaces'
        }
      }
    ]    
  }
  dependsOn: [
    vnetADBName_resource
  ]  
}

resource vnetADBName_prvSubnetName 'Microsoft.Network/virtualNetworks/subnets@2020-05-01' = {
  name: '${vnetADBName}/${privateSubnetName}'
  properties: {
    addressPrefix: privateSubnetCidr
    networkSecurityGroup: {
      id: nsgName_resource.id
    }
    delegations: [
      {
        name: 'databricks-del-private'
        properties: {
          serviceName: 'Microsoft.Databricks/workspaces'
        }
      }
    ]    
  }
  dependsOn: [
    vnetADBName_pubSubnetName
  ]  
}

resource loadBalancerPublicIpName_resource 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: loadBalancerPublicIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

resource loadBalancerName_resource 'Microsoft.Network/loadBalancers@2019-04-01' = {
  location: location
  name: loadBalancerName
  sku: {
    name: 'Standard'
    //tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: loadBalancerFrontendConfigName
        properties: {
          publicIPAddress: {
            id: loadBalancerPublicIpName_resource.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: loadBalancerBackendPoolName
        //type: 'Microsoft.Network/loadBalancers/backendAddressPools'
      }
    ]
    outboundRules: [
      {
        name: 'databricks-outbound-rule'
        //type: 'Microsoft.Network/loadBalancers/outboundRules'
        properties: {
          allocatedOutboundPorts: 0
          protocol: 'All'
          enableTcpReset: true
          idleTimeoutInMinutes: 4
          backendAddressPool: {
            id: loadBalancerBackendPoolId
          }
          frontendIPConfigurations: [
            {
              id: loadBalancerFrontendConfigId
            }
          ]
        }
      }
    ]
  }
}

resource workspaceName_resource 'Microsoft.Databricks/workspaces@2018-04-01' = {
  location: location
  name: workspaceName
  sku: {
    name: pricingTier
  }
  properties: {
    managedResourceGroupId: managedResourceGroupId
    parameters: {
      customVirtualNetworkId: {
        value: vnetADBName_resource.id
      }
      customPublicSubnetName: {
        value: publicSubnetName
      }
      customPrivateSubnetName: {
        value: privateSubnetName
      }
      enableNoPublicIp: {
        value: disablePublicIp
      }
      loadBalancerId: {
        value: loadBalancerId
      }
      loadBalancerBackendPoolName: {
        value: loadBalancerBackendPoolName
      }
    }
  }
  dependsOn: [
    vnetADBName_prvSubnetName
  ]
}