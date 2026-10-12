//
//  DoHConfig.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/20.
//

import Foundation
import NetworkExtension

struct DoHConfig: Identifiable {
    let servers: [String]
    let serverURL: String
    let displayText: String

    // Derived from the config's data so SwiftUI sees the same identity across re-renders.
    var id: String { serverURL }

    static let presets: [DoHConfig] = [
        DoHConfig(servers: ["1.1.1.1", "1.0.0.1", "2606:4700:4700::1111", "2606:4700:4700::1001"], serverURL: "https://cloudflare-dns.com/dns-query", displayText: "Cloudflare DNS"),
        DoHConfig(servers: ["8.8.8.8", "8.8.4.4", "2001:4860:4860::8888", "2001:4860:4860::8844"], serverURL: "https://dns.google/dns-query", displayText: "Google Public DNS"),
    ]

    func makeSettings() -> NEDNSOverHTTPSSettings {
        let settings = NEDNSOverHTTPSSettings(servers: servers)
        settings.serverURL = URL(string: serverURL)
        return settings
    }
}
