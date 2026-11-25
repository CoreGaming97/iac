param Prefix string = 'iac'

param DeployNIC bool = true 

resource vnetHub 'Microsoft.Network/virtualNetworks@2026-03-01' = {
  name: '${Prefix}-VNet-Hub'
  location: 'North Europe'
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

resource nic 'Microsoft.Network/networkInterfaces@2026-03-01' = [ for i in range (0,4) : if (DeployNIC == true) {
  
  name: '${Prefix}-NIC-${(i + 1)}'
  
  location: 'North Europe'
  properties: {
    ipConfigurations: [
      {
        name: 'FirstConfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets',vnetHub.name,'Test1')
          }
        }  
      }
    ]
  enableAcceleratedNetworking: true
  }
}]

/*
resource nic 'Microsoft.Network/networkInterfaces@2026-03-01' = [ for i in range (0,4) : if (DeployNIC == true) {
  
  name: '${Prefix}-NIC-${(i + 1)}'
  
  location: 'North Europe'
  properties: {
    ipConfigurations: [
      {
        name: 'FirstConfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets',vnetHub.name,'Test1')
          }
        }
      }
    ]
  }
}]
*/

output SubnetID string = resourceId('Microsoft.Network/virtualNetworks/subnets',vnetHub.name,'Test1')
