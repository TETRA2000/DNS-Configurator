//
//  DNSSettings.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/21.
//

import NetworkExtension

@MainActor
class DNSSettings: ObservableObject {
    @Published var active: NEDNSOverHTTPSSettings? = nil {
        didSet {
            if active == nil {
                resolverEnabled = false
            }
        }
    }
    @Published var resolverEnabled: Bool = false

    private var manager: NEDNSSettingsManager { NEDNSSettingsManager.shared() }

    // The async NetworkExtension APIs resume on the main actor, so state is
    // only ever mutated from the main thread.
    func loadDoH() async {
        do {
            try await manager.loadFromPreferences()
        } catch {
            print(error)
            active = nil
            return
        }

        if let dnsSettings = manager.dnsSettings as? NEDNSOverHTTPSSettings {
            active = dnsSettings
            resolverEnabled = manager.isEnabled
        } else {
            active = nil
        }
    }

    func applyDoH(config: DoHConfig) async {
        do {
            try await manager.loadFromPreferences()
            let dohSettings = config.makeSettings()
            manager.dnsSettings = dohSettings
            try await manager.saveToPreferences()
            active = dohSettings
            resolverEnabled = manager.isEnabled
        } catch {
            print(error.localizedDescription)
        }
    }

    func removeDoH() async {
        do {
            try await manager.removeFromPreferences()
            active = nil
        } catch {
            print(error.localizedDescription)
        }
    }

}
