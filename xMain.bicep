param Prefix string = 'iac'

module vNetHub 'xModuleVNet.bicep' = {
  name: 'iac-VNet-Hub'
  params: {
    Prefix: Prefix
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2026-03-01' = [ for i in range (0,5) : {
  
  name: '${Prefix}-NIC-${(i + 1)}'
  location: 'North Europe'
  properties: {
    ipConfigurations: [
      {
        name: 'FirstConfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets',vNetHub.outputs.name,'Test1')
          }
        }
      }
    ]
  }
}]
