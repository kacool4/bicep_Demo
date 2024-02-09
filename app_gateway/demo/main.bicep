param applicationGateways_azeuw_agwt02_name string = 'azeuw-agwt02'
param virtualNetworks_AZEUW_NETBEN01_name string = 'morpheus-vnet'

param location string = 'westeurope'

param SSLCertBase64String string = ''
param SSLCertDisplayName string = 'DemoCert'


module publicipaddress_azeuw_pipagwt02 '../Module/publicipaddress/main.bicep' = {
  name: 'publicipaddress_azeuw_pipagwt02'
      params: {
        location: location
        name_publicipaddress: 'dimidemotest'
        //tags: resourcetags
        publicipaddress_sku: {
          name: 'Standard'
          tier: 'Regional'
        }
        publicipaddress_properties: {
          publicIPAddressVersion: 'IPv4'
          publicIPAllocationMethod: 'Static'
          idleTimeoutInMinutes: 4
          dnsSettings: {
            domainNameLabel: 'dimidemont'
            fqdn: 'dimidemonewtest.westeurope.cloudapp.azure.com'
          }
          ipTags: []
        }
      }
    }



module applicationgateway_azeuw_agwt02 '../Module/appgateway/main.bicep' = {
  name: 'applicationgateway_azeuw_agwt02'
  params:{
    location: location
    name_applicationgateway: applicationGateways_azeuw_agwt02_name
    //tags: resourcetags
    applicationgateway_properties_sku: {
      name: 'WAF_v2'
      tier: 'WAF_v2'
    }

  

    applicationgateway_properties_gatewayIPConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_AZEUW_NETBEN01_name,'appgw')
          }
        }
      }
    ]

    
     applicationgateway_properties_sslCertificates: [
      {
        name: SSLCertDisplayName
        properties: {
          keyVaultSecretId: SSLCertBase64String
        }
      }
    ]


    applicationgateway_properties_trustedRootCertificates: []

    
    applicationgateway_properties_frontendIPConfigurations: [
      {
        name: 'publicfrontendip'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicipaddress_azeuw_pipagwt02.outputs.id
          }
        }
      }
    ]


   applicationgateway_properties_frontendPorts: [
      {
        name: 'frontendportssl'
        properties: {
          port: 443
        }
      }
      {
        name: 'frontendport'
        properties: {
          port: 80
        }
      }
    ]


   applicationgateway_properties_backendAddressPools: [
      {
        name: 'hive-hivegatewaysignalrdev-backendpool'
        properties: {
          backendAddresses: [
            {
              ipAddress: '10.96.134.62'
            }
          ]
        }
      }
    ]


  /*    applicationgateway_properties_backendHttpSettingsCollection: [
      {
        name: 'hive-admindev-backendhttpsettings'
        properties: {
          port: 7002
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          requestTimeout: 30
          probe: {
            id: '${resourceId('Microsoft.Network/applicationGateways',applicationGateways_azeuw_agwt02_name)}/probes/hive-admindev-probe'
          }
        }
      } 
    ]


    applicationgateway_properties_httpListeners: [
      {
        name: 'hive-admindev-httpslistener'
        properties: {
          frontendIPConfiguration: {
            id: '${resourceId('Microsoft.Network/applicationGateways',applicationGateways_azeuw_agwt02_name)}/frontendIPConfigurations/publicfrontendip'
          }
          frontendPort: {
            id: '${resourceId('Microsoft.Network/applicationGateways',applicationGateways_azeuw_agwt02_name)}/frontendPorts/frontendportssl'
          }
          protocol: 'Https'
          sslCertificate: {
            id: '${resourceId('Microsoft.Network/applicationGateways',applicationGateways_azeuw_agwt02_name)}/sslCertificates/Demo_Cert'
          }
          hostName: 'admin2-dev.mtu-go.com'
          hostNames: []
          requireServerNameIndication: true
        }
      }
    ]


    applicationgateway_properties_urlPathMaps: [
      {
        name: 'hive-hivegatewaydev-urlpathmap'
        properties: {
          defaultBackendAddressPool: {
            id: '${resourceId('Microsoft.Network/applicationGateways',applicationGateways_azeuw_agwt02_name)}/backendAddressPools/hive-hivegatewaydev-backendpool'
          }
          defaultBackendHttpSettings: {
            id: '${resourceId('Microsoft.Network/applicationGateways',applicationGateways_azeuw_agwt02_name)}/backendHttpSettingsCollection/hive-hivegatewaydev-backendhttpsettings'
          }
          pathRules: [
            {
              name: 'hive-hivegatewaysignalrdev-pathrulename'
              properties: {
                paths: [
                  '/api/v1/notifications/signalr*'
                ]
                backendAddressPool: {
                  id: '${resourceId('Microsoft.Network/applicationGateways',applicationGateways_azeuw_agwt02_name)}/backendAddressPools/hive-hivegatewaysignalrdev-backendpool'
                }
                backendHttpSettings: {
                  id: '${resourceId('Microsoft.Network/applicationGateways',applicationGateways_azeuw_agwt02_name)}/backendHttpSettingsCollection/hive-hivegatewaysignalrdev-backendhttpsettings'
                }
                rewriteRuleSet: {
                  id: '${resourceId('Microsoft.Network/applicationGateways',applicationGateways_azeuw_agwt02_name)}/rewriteRuleSets/rewriterule-all'
                }
              }
            }
          ]
        }
      }
      
    ]
    
    applicationgateway_properties_requestRoutingRules: [
      {
        name: 'hive-hivegatewaydev-routingrule'
        properties: {
          ruleType: 'PathBasedRouting'
          httpListener: {
            id: '${resourceId('Microsoft.Network/applicationGateways',applicationGateways_azeuw_agwt02_name)}/httpListeners/hive-hivegatewaydev-httpslistener'
          }
          urlPathMap: {
            id: '${resourceId('Microsoft.Network/applicationGateways',applicationGateways_azeuw_agwt02_name)}/urlPathMaps/hive-hivegatewaydev-urlpathmap'
          }
        }
      }
    ]


    applicationgateway_properties_probes: [
      {
        name: 'hive-admindev-probe'
        properties: {
          protocol: 'Http'
          host: '10.96.134.62'
          path: '/'
          interval: 30
          timeout: 10
          unhealthyThreshold: 3
          pickHostNameFromBackendHttpSettings: false
          minServers: 0
          match: {}
        }
      }
    ]

    
    applicationgateway_properties_rewriteRuleSets: [
      {}
    ]



    applicationgateway_properties_redirectConfigurations: [
      {
        name: 'hive-admindev-redirectconfiguration'
        properties: {
          redirectType: 'Permanent'
          targetListener: {
            id: '${resourceId('Microsoft.Network/applicationGateways',applicationGateways_azeuw_agwt02_name)}/httpListeners/hive-admindev-httpslistener'
          }
          requestRoutingRules: [
            {
              id: '${resourceId('Microsoft.Network/applicationGateways',applicationGateways_azeuw_agwt02_name)}/requestRoutingRules/hive-admindev-redirectrule'
            }
          ]
        }
      }
    ]

    
    applicationgateway_properties_sslPolicy: {
      policyType: 'Custom'
      minProtocolVersion: 'TLSv1_2'
      cipherSuites: [
        'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256'
        'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384'
        'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA'
        'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA'
        'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256'
        'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384'
        'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384'
        'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256'
        'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA'
        'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA'
      ]
    }
    applicationgateway_properties_webApplicationFirewallConfiguration: {
      enabled: true
      firewallMode: 'Prevention'
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.0'
      disabledRuleGroups: []
      exclusions: []
      requestBodyCheck: true
      maxRequestBodySizeInKb: 128
      fileUploadLimitInMb: 100
    }
    applicationgateway_properties_forceFirewallPolicyAssociation: true
    
 
    applicationgateway_properties_autoscaleConfiguration: {
      minCapacity: 0
      maxCapacity: 2
    }*/
  }
}
 