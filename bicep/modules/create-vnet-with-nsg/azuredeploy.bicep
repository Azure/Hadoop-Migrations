@description('Location of the resources')
param location string = resourceGroup().location

@description('Name for the VNet')
param VNetName string = 'vnet001'

@description('Address Space Prefix of the VNet')
param addressSpacePrefix string = '10.0.0.0/16'

@description('Name of the Subnet1')
param subnet1Name string = 'subnet1'

@description('Address Prefix of the Subnet1')
param subnet1Prefix string = '10.0.1.0/24'

@description('Name of the Subnet2')
param subnet2Name string = 'subnet2'

@description('Address Prefix of the Subnet2')
param subnet2Prefix string = '10.0.2.0/24'

@description('Name of the Subnet3')
param subnet3Name string = 'subnet3'

@description('Address Prefix of the Subnet3')
param subnet3Prefix string = '10.0.3.0/24'

@description('Network Security Group Name for all subnets')
param networkSecurityGroupName string = 'nsg001'  

var privateEndpointNetworkPolicies = 'Disabled'
var networkSecurityGroupId = resourceId('Microsoft.Network/networkSecurityGroups', networkSecurityGroupName)

module stgNSG '../create-nsg/azuredeploy.bicep' = {
  name: 'create-network-security-group'
  params: {
    nsgName: networkSecurityGroupName
    location: location
  }
}

/* colection assignment's not supported currently
resource subnetName_resources 'Microsoft.Network/virtualNetworks/subnets@2020-05-01' = [for item in subnets: {
  name: item.name
  properties: {
    addressPrefix: item.prefix
    privateEndpointNetworkPolicies: privateEndpointNetworkPolicies
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', networkSecurityGroupName)
    }
  }
  dependsOn: [
    stgNSG
  ]    
}]
*/

resource VNetName_resource 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: VNetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpacePrefix 
      ]
    }
    //subnets: subnetName_resources
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1Prefix
          privateEndpointNetworkPolicies: privateEndpointNetworkPolicies
          networkSecurityGroup: {
            id: networkSecurityGroupId
          }
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2Prefix
          privateEndpointNetworkPolicies: privateEndpointNetworkPolicies
          networkSecurityGroup: {
            id: networkSecurityGroupId
          }
        }
      }
      {
        name: subnet3Name
        properties: {
          addressPrefix: subnet3Prefix
          privateEndpointNetworkPolicies: privateEndpointNetworkPolicies
          networkSecurityGroup: {
            id: networkSecurityGroupId
          }
        }
      }
    ]
  }
  dependsOn: [
    stgNSG
  ]  
}

output outputmessage string = '${VNetName} creation done successfully'