@description('Location for the resources')
param location string = resourceGroup().location

@description('The name of you Virtual Machine.')
param vmName string = 'simpleLinuxVM1'

@description('Username for the Virtual Machine.')
param adminUsername string = 'azureuser'

@allowed([
  'sshPublicKey'
  'password'
])
@description('Type of authentication to use on the Virtual Machine. SSH key is recommended.')
param authenticationType string = 'password'

@description('SSH Key Name stored in the current Resource Group')
param storedSSHKeyName string

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string = toLower('${vmName}-${uniqueString(resourceGroup().id)}')

@allowed([
  '12.04.5-LTS'
  '14.04.5-LTS'
  '16.04.0-LTS'
  '18.04-LTS'
])
@description('The Ubuntu version for the VM. This will pick a fully patched image of this given Ubuntu version.')
param ubuntuOSVersion string = '18.04-LTS'

@description('The size of the VM')
param vmSize string = 'Standard_B2s'

@description('Name of the VNET')
param virtualNetworkName string = 'vNet'

@description('Name of the subnet in the virtual network')
param subnetName string = 'Subnet'

@description('Name of the Network Security Group')
param networkSecurityGroupName string = 'SecGroupNet'

resource sshKeyName_resource 'Microsoft.Compute/sshPublicKeys@2020-12-01' existing = {
  name: storedSSHKeyName
}

// VM Creation for test at Blue, Mgmt each
module stgVM '../create-vm-simple-linux/azuredeploy.bicep' = {
  name: 'create-vm-mgmt'
  params: {
    location: location
    vmName: vmName
    vmSize: vmSize
    virtualNetworkName: virtualNetworkName
    subnetName: subnetName
    networkSecurityGroupName : networkSecurityGroupName
    adminUsername: adminUsername
    authenticationType: authenticationType
    adminPasswordOrKey: sshKeyName_resource.properties.publicKey
    dnsLabelPrefix: dnsLabelPrefix
    ubuntuOSVersion: ubuntuOSVersion
  }
}

output outputmessage string = '${vmName} creation done successfully'