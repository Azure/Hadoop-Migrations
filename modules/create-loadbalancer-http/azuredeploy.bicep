@description('Specifies a project name that is used for generating resource names.')
param projectName string

@description('Specifies the location for all of the resources created by this template.')
param location string = resourceGroup().location

var lbName_var = '${projectName}-lb'
var lbSkuName = 'Standard'
var lbPublicIpAddressName_var = '${projectName}-lbPublicIP'
var lbPublicIPAddressNameOutbound_var = '${projectName}-lbPublicIPOutbound'
var lbFrontEndName = 'LoadBalancerFrontEnd'
var lbFrontEndNameOutbound = 'LoadBalancerFrontEndOutbound'
var lbBackendPoolName = 'LoadBalancerBackEndPool'
var lbBackendPoolNameOutbound = 'LoadBalancerBackEndPoolOutbound'
var lbProbeName = 'loadBalancerHealthProbe'
var nsgName_var = '${projectName}-nsg'

resource lbName 'Microsoft.Network/loadBalancers@2020-06-01' = {
  name: lbName_var
  location: location
  sku: {
    name: lbSkuName
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: lbFrontEndName
        properties: {
          publicIPAddress: {
            id: lbPublicIPAddressName.id
          }
        }
      }
      {
        name: lbFrontEndNameOutbound
        properties: {
          publicIPAddress: {
            id: lbPublicIPAddressNameOutbound.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: lbBackendPoolName
      }
      {
        name: lbBackendPoolNameOutbound
      }
    ]
    loadBalancingRules: [
      {
        name: 'myHTTPRule'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName_var, lbFrontEndName)
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName_var, lbBackendPoolName)
          }
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 15
          protocol: 'Tcp'
          enableTcpReset: true
          loadDistribution: 'Default'
          disableOutboundSnat: true
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', lbName_var, lbProbeName)
          }
        }
      }
    ]
    probes: [
      {
        name: lbProbeName
        properties: {
          protocol: 'Http'
          port: 80
          requestPath: '/'
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
    ]
    outboundRules: [
      {
        name: 'myOutboundRule'
        properties: {
          allocatedOutboundPorts: 10000
          protocol: 'All'
          enableTcpReset: false
          idleTimeoutInMinutes: 15
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName_var, lbBackendPoolNameOutbound)
          }
          frontendIPConfigurations: [
            {
              id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName_var, lbFrontEndNameOutbound)
            }
          ]
        }
      }
    ]
  }
}

resource lbPublicIPAddressName 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: lbPublicIpAddressName_var
  location: location
  sku: {
    name: lbSkuName
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
}

resource lbPublicIPAddressNameOutbound 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: lbPublicIPAddressNameOutbound_var
  location: location
  sku: {
    name: lbSkuName
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
}

resource nsgName 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: nsgName_var
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowHTTPInbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}