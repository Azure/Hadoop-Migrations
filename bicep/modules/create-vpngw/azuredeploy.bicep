@description('Location of the resources')
param location string = resourceGroup().location

@description('Name of the VPN GW')
param vpnGWName string

@description('SKU of the VPN GW')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param sku string = 'Standard'

@description('Generation of the VPN GW')
param vpnGWGeneration string = 'Generation1'

@description('Type of the VPN GW, check this page for SKU and Generation of VPN GW https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways')
@allowed([
  'Vpn'
  'ExpressRoute'
])
param gatewayType string = 'Vpn'

@allowed([
  'RouteBased'
  'PolicyBased'
])
param vpnType string = 'RouteBased'
param vnetName string
param vpnGWSubnetName string = 'GatewaySubnet'
param vpnGWSubnetAddressPrefix string
param vpnGWPublicIPAddressName string = '${vpnGWName}-ip'

resource vpnGWPublicIPAddressName_resource 'Microsoft.Network/publicIPAddresses@2019-02-01' = {
  name: vpnGWPublicIPAddressName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource vnetName_vpnGWSubnetName 'Microsoft.Network/virtualNetworks/subnets@2019-04-01' = {
  name: '${vnetName}/${vpnGWSubnetName}'
  properties: {
    addressPrefix: vpnGWSubnetAddressPrefix
  }
}

resource vpnName_resource 'Microsoft.Network/virtualNetworkGateways@2020-08-01' = {
  name: vpnGWName
  location: location
  properties: {
    gatewayType: gatewayType
    ipConfigurations: [
      {
        name: 'default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            //id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, vpnGWSubnetName)
            id: vnetName_vpnGWSubnetName.id
          }
          publicIPAddress: {
            //id: resourceId('Microsoft.Network/publicIPAddresses', vpnGWPublicIPAddressName)
            id: vpnGWPublicIPAddressName_resource.id
          }
        }
      }
    ]
    vpnType: vpnType
    vpnGatewayGeneration: vpnGWGeneration
    sku: {
      name: sku
      tier: sku
    }
  }
  dependsOn: [
    vnetName_vpnGWSubnetName
    vpnGWPublicIPAddressName_resource
  ]
}

