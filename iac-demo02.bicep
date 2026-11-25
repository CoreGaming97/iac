
targetScope = 'resourceGroup'

param Prefix string = 'iac'

resource sa1 'Microsoft.Storage/storageAccounts@2026-09-01' = {
  name: '${Prefix}sa0123'
  location: 'North Europe'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  tags: {
    Author: 'Gabriel Horn'
    'hidden-title': 'IAC Demo StorageAccount'
  }
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
  }
}

output saname string = sa1.name
