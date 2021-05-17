@description('Private DNS zone name')
param privateDnsZoneName string = 'contoso.com'

@description('Enable automatic VM DNS registration in the zone')
param vmRegistration bool = true

@description('VNet name')
param vnetName string = 'VNet1'

@description('Address prefix')
param vnetAddressPrefix string = '10.0.0.0/24' // 16

@description('Location for all resources.')
param location string = resourceGroup().location

resource vnetName_resource 'Microsoft.Network/virtualNetworks@2020-05-01' existing = {
  name: vnetName
}

resource privateDnsZoneName_resource 'Microsoft.Network/privateDnsZones@2020-01-01' = {
  name: privateDnsZoneName
  location: 'global'
}

resource privateDnsZoneName_privateDnsZoneName_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-01-01' = {
  name: '${privateDnsZoneName_resource.name}/${privateDnsZoneName}-link'
  location: 'global'
  properties: {
    registrationEnabled: vmRegistration
    virtualNetwork: {
      id: vnetName_resource.id
    }
  }
}

output outputmessage string = '${privateDnsZoneName} creation done successfully'