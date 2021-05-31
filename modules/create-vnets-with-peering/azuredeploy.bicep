@description('Location of the resources')
param location string = resourceGroup().location

@description('Name for vNet 1')
param vNet1Name string = 'vNet1'

@description('Name for vNet 2')
param vNet2Name string = 'vNet2'

@description('Config  for vNet 1')
param vNet1Config object = {
  addressSpacePrefix: '10.0.0.0/16'
  subnetName: 'subnet1'
  subnetPrefix: '10.0.0.0/24'
}

@description('Config  for vNet 2')
param vNet2Config object = {
  addressSpacePrefix: '192.168.0.0/16'
  subnetName: 'subnet1'
  subnetPrefix: '192.168.0.0/24'
}

@description('Private DNS zone name')
param privateDnsZoneName string = 'contoso.com'

@description('Enable automatic VM DNS registration in the zone')
param vmRegistration bool = true

var vNet1tovNet2PeeringName = '${vNet1Name}-${vNet2Name}'
var vNet2tovNet1PeeringName = '${vNet2Name}-${vNet1Name}'

resource vNet1Name_resource 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: vNet1Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNet1Config.addressSpacePrefix
      ]
    }
    subnets: [
      {
        name: vNet1Config.subnetName
        properties: {
          addressPrefix: vNet1Config.subnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

resource vNet1Name_vNet1tovNet2PeeringName 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  name: '${vNet1Name_resource.name}/${vNet1tovNet2PeeringName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vNet2Name_resource.id
    }
  }
}

resource vNet2Name_resource 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: vNet2Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNet2Config.addressSpacePrefix
      ]
    }
    subnets: [
      {
        name: vNet2Config.subnetName
        properties: {
          addressPrefix: vNet2Config.subnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

resource vNet2Name_vNet2tovNet1PeeringName 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  name: '${vNet2Name_resource.name}/${vNet2tovNet1PeeringName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vNet1Name_resource.id
    }
  }
}

output outputmessage string = '${vNet1Name} ${vNet2Name} creation done successfully with peering'