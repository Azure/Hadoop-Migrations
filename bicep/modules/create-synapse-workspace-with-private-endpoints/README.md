# Create an Azure Synapse workspace instance

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fnudbeach%2Fdata-platform-migration%2Fmain%2Fmodules%2Fcreate-synapse-workspace-with-private-endpoints%2Fazuredeploy.json)
[![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.svg)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fnudbeach%2Fdata-platform-migration%2Fmain%2Fmodules%2Fcreate-synapse-workspace-with-private-endpoints%2Fazuredeploy.json)


**Create an Azure Synapse workspace instance**

The template creates and configures the following Azure resources:

- Synapse Workspace
- Firewall rules
- SQL Pool
- Spark Pool
- End points
- Private DNS Zone settings

Find 'Before you start' from [here](../../README.md#before-you-start) for the prerequisites to run this from your command line

After you login by `az login` from command line,

```command
az deployment group create -g <Your Resource Group Name> -f azuredeploy.bicep
```

or 

```command
az deployment group create -g <Your Resource Group Name> -f azuredeploy.bicep --parameters azuredeploy.parameters.json
```

It normally takes minutes to complete. Check the status from the portal 'Resource Groups' > '<Your Resource Group>' > 'Deployments'