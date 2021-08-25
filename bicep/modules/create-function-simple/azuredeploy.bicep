@description('Location of the resources')
param location string = resourceGroup().location 

@description('Function App Name')
param fxnAppName string = 'fxn-krc-003'

@description('Function App Kind')
param fxnAppKind string = 'functionapp,linux'

@description('Runtime Type & Version')
param linuxFxVersion string = 'Node|14'

resource fxnAppName_resource 'Microsoft.Web/sites@2018-11-01' = {
  name: fxnAppName
  location: location
  kind: fxnAppKind
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${fxnAppName}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${fxnAppName}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    reserved: true
    isXenon: false
    hyperV: false
    siteConfig: {
      numberOfWorkers: 1
      linuxFxVersion: linuxFxVersion
      alwaysOn: false
      http20Enabled: false
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    hostNamesDisabled: false
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    httpsOnly: false
    redundancyMode: 'None'
  }
}

resource fxnAppName_web 'Microsoft.Web/sites/config@2018-11-01' = {
  name: '${fxnAppName_resource.name}/web'
  location: location
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
    ]
    netFrameworkVersion: 'v4.0'
    linuxFxVersion: linuxFxVersion
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$${fxnAppName}'
    azureStorageAccounts: {}
    scmType: 'None'
    use32BitWorkerProcess: false
    webSocketsEnabled: false
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 1
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 1
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    ftpsState: 'AllAllowed'
    reservedInstanceCount: 0
  }
}

resource fxnAppName_fxnAppName_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2018-11-01' = {
  name: '${fxnAppName_resource.name}/${fxnAppName}.azurewebsites.net'
  location: location
  properties: {
    siteName: fxnAppName
    hostNameType: 'Verified'
  }
}