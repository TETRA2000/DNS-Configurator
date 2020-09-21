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
}
