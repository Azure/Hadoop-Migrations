@description('Location of the resources')
param location string = resourceGroup().location

@description('SSH Key Name to be stored with')
param sshKeyName string = 'sshKeyName'

@description('SSH Key String, starts with ssh-rsa')
@secure()
param sshKeyValue string

resource sshKeyName_rcs 'Microsoft.Compute/sshPublicKeys@2020-12-01' = {
  name: sshKeyName
  location: location
  properties: {
    publicKey: sshKeyValue
  }
}