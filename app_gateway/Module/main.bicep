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
param applicationgateway_properties_firewallPolicy object = {}
param applicationgateway_properties_autoscaleConfiguration object = {}
param tags object = {}

@description('Azure Location')
param location string = 'westeurope'

resource applicationgateway 'Microsoft.Network/applicationGateways@2020-11-01' = {
  name: name_applicationgateway
  location: location
  tags: tags
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
    firewallPolicy: applicationgateway_properties_firewallPolicy
    autoscaleConfiguration: applicationgateway_properties_autoscaleConfiguration
  }
}

output id string = applicationgateway.id
