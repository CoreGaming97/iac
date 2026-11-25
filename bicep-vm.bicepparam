using './bicep-vm.bicep'

param adminUsername = 'localadmin'
param adminPassword = getSecret('eec0968d-6c7a-40df-b5a5-a1ce6558617e','RG-IaC-Gabriel','iac-kv-019','VMadminPassword')

