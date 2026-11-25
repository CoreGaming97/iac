param Prefix string = 'iac'
param Location string = 'France Central'

param DeployNIC bool = true 

resource vnetHub 'Microsoft.Network/virtualNetworks@2026-03-01' = {
  name: '${Prefix}-VNet-Hub'
  location: Location
  properties: {
    addressSpace: {
      addressPrefixes: [
      '10.200.0.0/16'
      ]
  }
  subnets: [
    {
      name: 'CentralResources'
      properties: {
        addressPrefix: '10.200.1.0/24'
      }
    }
        {
      name: 'Test1'
      properties: {
        addressPrefix: '10.200.2.0/24'
      }
    }
        {
      name: 'Test2'
      properties: {
        addressPrefix: '10.200.3.0/24'
      }
    }
  ]
}
}

output name string = vnetHub.name
