//
//  DNSSettings.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/21.
//

import NetworkExtension

class DNSSettings: ObservableObject {
    @Published var active: NEDNSOverHTTPSSettings? = nil {
        didSet {
            if active == nil {
                resolverEnabled = false
            }
        }
    }
    @Published var resolverEnabled: Bool = false
    
    func loadDoH() {
        NEDNSSettingsManager.shared().loadFromPreferences { loadError in
            if let loadError = loadError {
                print(loadError)
                self.active = nil
                return
            }
            
            if let dnsSettings = NEDNSSettingsManager.shared().dnsSettings as? NEDNSOverHTTPSSettings {
                self.active = dnsSettings
                self.resolverEnabled = NEDNSSettingsManager.shared().isEnabled
            } else {
                self.active = nil
            }
        }
    }
    
    func removeDoH() {
        NEDNSSettingsManager.shared().removeFromPreferences(completionHandler: {
            removeError in
            // TODO
            if let removeError = removeError {
                print(removeError.localizedDescription)
                return
            }
            
            self.active = nil
        })
    }
    
}
