@description('Location for the resources.')
param location string = resourceGroup().location

@minLength(3)
@maxLength(63)
@description('Stream Analytics Job Name, can contain alphanumeric characters and hypen and must be 3-63 characters long')
param streamAnalyticsJobName string

@minValue(1)
@maxValue(48)
@allowed([
  1
  3
  6
  12
  18
  24
  30
  36
  42
  48
])
@description('Number of Streaming Units')
param numberOfStreamingUnits int

resource streamAnalyticsJobName_resource 'Microsoft.StreamAnalytics/StreamingJobs@2019-06-01' = {
  name: streamAnalyticsJobName
  location: location
  properties: {
    sku: {
      name: 'standard'
    }
    outputErrorPolicy: 'stop'
    eventsOutOfOrderPolicy: 'adjust'
    eventsOutOfOrderMaxDelayInSeconds: 0
    eventsLateArrivalMaxDelayInSeconds: 5
    dataLocale: 'en-US'
    transformation: {
      name: 'Transformation'
      properties: {
        streamingUnits: numberOfStreamingUnits
        query: 'SELECT\r\n    *\r\nINTO\r\n    [YourOutputAlias]\r\nFROM\r\n    [YourInputAlias]'
      }
    }
  }
}