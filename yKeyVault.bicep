targetScope = 'resourceGroup'

resource kv 'Microsoft.KeyVault/vaults@2026-05-15' = {
  name: 'iac-kv-019'
  location: 'France Central'
  properties: {
    sku: {
      name:  'standard'
      family:  'A'
    }
    tenantId: subscription().tenantId
    enableSoftDelete: false
    publicNetworkAccess: 'Enabled'
    enableRbacAuthorization: true
  }
}
