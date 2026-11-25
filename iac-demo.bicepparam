using './iac-demo.bicep'

param iaclocation = 'West Europe'
param Prefix = 'cw48'
param ipAdresses = [
  '192.168.100.1'
  '192.168.100.2'
  '192.168.100.3'
]
param Config = {
  kind: 'Blob'
  SKU: 'Standard_LRS'
}

