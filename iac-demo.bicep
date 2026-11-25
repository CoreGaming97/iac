targetScope = 'resourceGroup'

@allowed(['North Europe', 'West Europe', 'Austria East','Germany West Central'])
param iaclocation string = 'Austria East'

@minLength(2)
@maxLength(4)
@description('Specify a prefix for the Resource')
param Prefix string = 'iac'

param ipAdresses array 

param Config object = {
  kind: 'StandardV2'
  SKU: 'Standard_LRS'
}

@description('VM Name with Prefix')
var VMName string = '${Prefix}-VM-DC1'
var VMSize string = 'Standard_B4s_v2'

output Location string = iaclocation
output VMName string = VMName
output VMSize string = VMSize

output Prefix string = Prefix
output IpAddresses array = ipAdresses
output ConfigKind string = Config.Kind
output ConfigSKU string = Config.SKU
output Config object = Config
