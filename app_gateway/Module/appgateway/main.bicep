param name_applicationgateway string
param applicationgateway_properties_sku object = {}
param applicationgateway_properties_gatewayIPConfigurations array = []
param applicationgateway_properties_sslCertificates array = []
param applicationgateway_properties_trustedRootCertificates array = []
param applicationgateway_properties_frontendIPConfigurations array = []
param applicationgateway_properties_frontendPorts array = []
param applicationgateway_properties_backendAddressPools array = []
param applicationgateway_properties_backendHttpSettingsCollection array = []
param applicationgateway_properties_httpListeners array = []
param applicationgateway_properties_urlPathMaps array = []
param applicationgateway_properties_requestRoutingRules array = []
param applicationgateway_properties_probes array = []
param applicationgateway_properties_rewriteRuleSets array = []
param applicationgateway_properties_redirectConfigurations array = []
param applicationgateway_properties_sslPolicy object = {}
param applicationgateway_properties_webApplicationFirewallConfiguration object = {}
param applicationgateway_properties_forceFirewallPolicyAssociation bool = true
param applicationgateway_properties_autoscaleConfiguration object = {}
param tags object = {}
param applicationgateway_properties_identity object = {}

param ManagedIdentity_name string
param ManagedIdentity_location string


@description('Azure Location')
param location string = 'westeurope'

resource applicationgateway 'Microsoft.Network/applicationGateways@2021-08-01' = {
  name: name_applicationgateway
  location: location
  tags: tags
  identity: applicationgateway_properties_identity
  properties: {
    sku: applicationgateway_properties_sku
    gatewayIPConfigurations: applicationgateway_properties_gatewayIPConfigurations
    sslCertificates: applicationgateway_properties_sslCertificates
    trustedRootCertificates: applicationgateway_properties_trustedRootCertificates
    trustedClientCertificates: []
    sslProfiles: []
    frontendIPConfigurations: applicationgateway_properties_frontendIPConfigurations
    frontendPorts: applicationgateway_properties_frontendPorts
    backendAddressPools: applicationgateway_properties_backendAddressPools
    backendHttpSettingsCollection: applicationgateway_properties_backendHttpSettingsCollection
    httpListeners: applicationgateway_properties_httpListeners
    urlPathMaps: applicationgateway_properties_urlPathMaps
    requestRoutingRules: applicationgateway_properties_requestRoutingRules
    probes: applicationgateway_properties_probes
    rewriteRuleSets: applicationgateway_properties_rewriteRuleSets
    redirectConfigurations: applicationgateway_properties_redirectConfigurations
    privateLinkConfigurations: []
    sslPolicy: applicationgateway_properties_sslPolicy
    webApplicationFirewallConfiguration: applicationgateway_properties_webApplicationFirewallConfiguration
    forceFirewallPolicyAssociation: applicationgateway_properties_forceFirewallPolicyAssociation
    autoscaleConfiguration: applicationgateway_properties_autoscaleConfiguration
  }
}

resource ManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: ManagedIdentity_name
  location: ManagedIdentity_location
}

resource AccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
  name: 'dimi-appgw-test/add'
  properties: {
    accessPolicies: [
      {
        objectId: ManagedIdentity.properties.principalId
        permissions: {
          certificates: [
            'get','list'
          ]
          secrets: [
            'get','list'
          ]
        }
        tenantId: '0010a289-cf71-4b3e-ae52-5f9978f05439' 
      }
    ]
  }
}
