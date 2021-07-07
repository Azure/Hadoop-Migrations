//// Parameters

@description('Location to create all resources')
param location string = resourceGroup().location

@description('Project name')
param projectName string = 'hdmp001'

param suffix string = 'hdp'
param uniqueString string = utcNow('yyyyMMddHHmmss')

param virtualNetworkName string = 'hdmp001vnet001'
param subnetName string = 'subnet1'
param adminUsername string = 'azureuser'
param adminStoredPublicKey string = 'DEFAULT01'

param osDiskType string = 'Premium_LRS'
param virtualMachineSize string = 'Standard_D4s_v3'

// Dev/Test - General purpose (D-Series), BYOL

param planName string = 'sandbox26'
param planPublisher string = 'hortonworks'
param planProduct string = 'hortonworks-sandbox'
param imagePublisher string = 'hortonworks'
param imageOffer string = 'hortonworks-sandbox'
param imageSKU string = 'sandbox26'
param imageVersion string = '2.6.4'

//// Variables

var virtualMachineName = toLower('${projectName}${suffix}-${uniqueString}')
var virtualMachineComputerName = virtualMachineName
var publicIpAddressName = '${virtualMachineName}ip'
var networkInterfaceName = '${virtualMachineName}nic'

var publicIpAddressType = 'Dynamic'
var publicIpAddressSku = 'Basic'

//var vnetId = virtualNetworkId
var vnetId = resourceId('Microsoft.Network/virtualNetworks', virtualNetworkName)
var subnetRef = '${vnetId}/subnets/${subnetName}'

resource sshKeyName_resource 'Microsoft.Compute/sshPublicKeys@2020-12-01' existing = {
  name: adminStoredPublicKey
}

resource networkInterfaceName_resource 'Microsoft.Network/networkInterfaces@2018-10-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetRef
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId(resourceGroup().name, 'Microsoft.Network/publicIpAddresses', publicIpAddressName)
          }
        }
      }
    ]
  }
  dependsOn: [
    publicIpAddressName_resource
  ]
}

resource publicIpAddressName_resource 'Microsoft.Network/publicIpAddresses@2019-02-01' = {
  name: publicIpAddressName
  location: location
  sku: {
    name: publicIpAddressSku
  }
  properties: {
    publicIPAllocationMethod: publicIpAddressType
  }
}

resource virtualMachineName_resource 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: virtualMachineName
  location: location
  plan: {
    name: planName
    publisher: planPublisher
    product: planProduct
  }
  properties: {
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: imageSKU
        version: imageVersion
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceName_resource.id
        }
      ]
    }
    osProfile: {
      computerName: virtualMachineComputerName
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: sshKeyName_resource.properties.publicKey
            }
          ]
        }
      }
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

output adminUsername string = adminUsername