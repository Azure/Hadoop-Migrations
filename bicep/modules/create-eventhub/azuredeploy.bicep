@description('Location of the resources')
param location string = resourceGroup().location 

@description('Event Hub Namespace Name')
param nsEventHub string = 'eh-krc-001'

@description('Event Hub Name')
param ehName string = 'eh001'

@description('Authorization Name')
param authName string = 'tester001'

@description('Consumer Group Name')
param consumerGroupName string = '$Default'

resource nsEventHub_resource 'Microsoft.EventHub/namespaces@2021-01-01-preview' = {
  name: nsEventHub
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
    capacity: 1
  }
  properties: {
    zoneRedundant: false
    isAutoInflateEnabled: false
    maximumThroughputUnits: 0
    kafkaEnabled: true
  }
}

resource nsEventHub_RootManageSharedAccessKey 'Microsoft.EventHub/namespaces/AuthorizationRules@2021-01-01-preview' = {
  name: '${nsEventHub_resource.name}/RootManageSharedAccessKey'
  properties: {
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
}

resource nsEventHubEHName 'Microsoft.EventHub/namespaces/eventhubs@2021-01-01-preview' = {
  name: '${nsEventHub_resource.name}/${ehName}'
  properties: {
    messageRetentionInDays: 1
    partitionCount: 1
    status: 'Active'
  }
}

resource nsEventHub_default 'Microsoft.EventHub/namespaces/networkRuleSets@2021-01-01-preview' = {
  name: '${nsEventHub_resource.name}/default'
  properties: {
    defaultAction: 'Deny'
    virtualNetworkRules: []
    ipRules: []
  }
}

resource nsEventHubEHNameAuthName 'Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2021-01-01-preview' = {
  name: '${nsEventHubEHName.name}/${authName}'
  properties: {
    rights: [
      'Manage'
      'Listen'
      'Send'
    ]
  }
  dependsOn: [
    nsEventHub_resource
  ]
}

resource nsEventHubEHNameConsumerGroupName 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2021-01-01-preview' = {
  name: '${nsEventHubEHName.name}/${consumerGroupName}'
  properties: {}
  dependsOn: [
    nsEventHub_resource
  ]
}