param name_publicipaddress string
param publicipaddress_properties object = {}
param publicipaddress_zones array = []
param publicipaddress_sku object = {}
param tags object = {}

@description ('Azure Location')
param location string = 'westeurope'

resource publicipaddress 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: name_publicipaddress
  location: location
  tags: tags
  sku: publicipaddress_sku
  zones: publicipaddress_zones
  properties: publicipaddress_properties 
}
output id string = publicipaddress.id
