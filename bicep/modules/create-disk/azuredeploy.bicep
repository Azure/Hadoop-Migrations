@description('Location of the resources')
param location string = resourceGroup().location

@description('Name of the Disk')
param diskName string = 'disk01'

@description('Size in GB of the Disk')
param diskSizeGB int = 4

@description('SKU of the Disk')
param diskSKU string = 'Premium_LRS'

resource diskName_resource 'Microsoft.Compute/disks@2020-12-01' = {
  name: diskName
  location: location
  sku: {
    name: diskSKU
  }
  properties:{
    creationData:{
      createOption: 'Empty'
    }
    diskSizeGB: diskSizeGB
  }
}