@maxLength(4)
param Prefix string = 'iac'

@maxLength(15)
param VMName string = 'VM'

param location string = 'France Central'

var fullVMName = '${Prefix}-${VMName}'
var fullVNetName = '${Prefix}-VNet'
var fullNICName = '${Prefix}-NIC'
var fullPubIPName = '${Prefix}-PubIP'
var fullNSGName = '${Prefix}-NSG'
var fullOSDiskName = '${Prefix}-OSDisk-${VMName}'

resource dscript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: '${Prefix}-DeploymentScript'
  kind: 'AzurePowerShell'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/eec0968d-6c7a-40df-b5a5-a1ce6558617e/resourcegroups/RG-IaC-Gabriel/providers/Microsoft.ManagedIdentity/userAssignedIdentities/iac-uami-gh': {}
    }
  }
  properties: {
    azPowerShellVersion: '15.0'
    arguments: '-VMName ${fullVMName} -RGName ${resourceGroup().name}'
    scriptContent: '''
      param (
      [parameter(Mandatory = $true)]    
      [string]$VMName,

      [parameter(Mandatory = $true)]
      [string]$RGName
      )

      Connect-AzAccount -Identity

      $DeploymentScriptOutputs = @{}
      
      $VM = Get-AzVM -Name $VMName -ResourceGroupName $RGName -Status

      if ($VM.statuses.code -contains "PowerState/running") {
          Stop-AzVM -Name $VMName -ResourceGroupName $RGName -Force
          Write-Output "The VM $VMName was stopped."
          $DeploymentScriptOutputs['result'] = 'Success'
      }
      else {
          Write-Output "The VM $VMName was NOT stopped."
          $DeploymentScriptOutputs['result'] = 'Failure'
      }


      '''
    timeout: 'PT10M'
    retentionInterval: 'PT1H'
    cleanupPreference: 'OnSuccess'
  }
}

resource VM 'Microsoft.Compute/virtualMachines@2025-11-01' = {
  name: fullVMName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2alds_v7'
    }
    osProfile: {
      computerName: VMName
      adminUsername: 'localadmin'
      adminPassword: 'P@ssw0rd1234!'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-Datacenter-g2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        name: fullOSDiskName
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: NIC.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
  }
}

resource NIC 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: fullNICName
  location: location
  tags: {
    Author: 'DIST'
    Course: 'IaC'
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', fullVNetName, 'Subnet-1')
          }
        }
      }
    ]
  }
  dependsOn: [
    VNet
    PubIP
  ]
}

resource VNet 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: fullVNetName
  location: location
  tags: {
    Author: 'DIST'
    Course: 'IaC'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.101.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'Subnet-1'
        properties: {
          addressPrefix: '10.101.0.0/24'
          networkSecurityGroup: {
            id: NSG.id
          }
        }
      }
      {
        name: 'Subnet-2'
        properties: {
          addressPrefix: '10.101.1.0/24'
          networkSecurityGroup: {
            id: NSG.id
          }
        }
      }
    ]
  }
}

resource PubIP 'Microsoft.Network/publicIPAddresses@2025-05-01' = {
  name: fullPubIPName
  location: location
  tags: {
    Author: 'DIST'
    Course: 'IaC'
  }
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource NSG 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: fullNSGName
  location: location
  properties: {
    securityRules: [
      {
        name: 'RDP-Allow'
        properties: {
          description: 'Allow RDP traffic'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 500
          direction: 'Inbound'
        }
      }
    ]
  }
}

output deploymentScriptResult string = dscript.properties.outputs.result
