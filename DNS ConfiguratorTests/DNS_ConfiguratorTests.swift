//
//  DNS_ConfiguratorTests.swift
//  DNS ConfiguratorTests
//
//  Created by Takahiko Inayama on 2020/09/20.
//

import XCTest
import NetworkExtension
@testable import DNS_Configurator

// MARK: - DoHConfig Tests

class DoHConfigTests: XCTestCase {

    func testIdentifierIsStableAcrossInstances() {
        // List rows must keep their identity when the view is rebuilt.
        let config1 = DoHConfig(servers: ["1.1.1.1"], serverURL: "https://example.com/dns-query", displayText: "Test")
        let config2 = DoHConfig(servers: ["1.1.1.1"], serverURL: "https://example.com/dns-query", displayText: "Test")

        XCTAssertEqual(config1.id, config2.id)
    }

    func testIdentifierDiffersForDifferentServerURLs() {
        let config1 = DoHConfig(servers: ["1.1.1.1"], serverURL: "https://a.example.com/dns-query", displayText: "A")
        let config2 = DoHConfig(servers: ["1.1.1.1"], serverURL: "https://b.example.com/dns-query", displayText: "B")

        XCTAssertNotEqual(config1.id, config2.id)
    }

    func testMakeSettingsCopiesServersAndURL() {
        let config = DoHConfig(
            servers: ["8.8.8.8", "2001:4860:4860::8888"],
            serverURL: "https://dns.google/dns-query",
            displayText: "Google Public DNS"
        )

        let settings = config.makeSettings()

        XCTAssertEqual(settings.servers, config.servers)
        XCTAssertEqual(settings.serverURL, URL(string: "https://dns.google/dns-query"))
    }
}

// MARK: - Preset Tests

class DoHConfigPresetTests: XCTestCase {

    func testPresetsAreNotEmpty() {
        XCTAssertFalse(DoHConfig.presets.isEmpty)
    }

    func testPresetIdentifiersAreUnique() {
        let ids = DoHConfig.presets.map(\.id)

        XCTAssertEqual(Set(ids).count, ids.count, "Duplicate IDs would break List row identity")
    }

    func testPresetIdentifiersAreStable() {
        XCTAssertEqual(DoHConfig.presets.map(\.id), DoHConfig.presets.map(\.id))
    }

    func testPresetsHaveDisplayTextAndServers() {
        for preset in DoHConfig.presets {
            XCTAssertFalse(preset.displayText.isEmpty)
            XCTAssertFalse(preset.servers.isEmpty, "\(preset.displayText) has no servers")
        }
    }

    func testPresetsProduceValidHTTPSSettings() {
        for preset in DoHConfig.presets {
            let settings = preset.makeSettings()

            XCTAssertEqual(settings.serverURL?.scheme, "https", "\(preset.displayText) must use HTTPS")
            XCTAssertNotNil(settings.serverURL?.host, "\(preset.displayText) has no host")
        }
    }

    func testPresetServersAreIPAddresses() {
        for preset in DoHConfig.presets {
            for server in preset.servers {
                XCTAssertTrue(isIPAddress(server), "\(server) in \(preset.displayText) is not an IP address")
            }
        }
    }

    private func isIPAddress(_ string: String) -> Bool {
        var ipv4 = in_addr()
        var ipv6 = in6_addr()
        return inet_pton(AF_INET, string, &ipv4) == 1 || inet_pton(AF_INET6, string, &ipv6) == 1
    }
}

// MARK: - DNSSettings Tests

@MainActor
class DNSSettingsTests: XCTestCase {

    func testInitialState() {
        let settings = DNSSettings()

        XCTAssertNil(settings.active)
        XCTAssertFalse(settings.resolverEnabled)
    }

    func testResolverDisabledWhenActiveSetToNil() {
        let settings = DNSSettings()
        settings.active = DoHConfig.presets[0].makeSettings()
        settings.resolverEnabled = true

        settings.active = nil

        XCTAssertFalse(settings.resolverEnabled, "resolverEnabled should become false when active is set to nil")
    }

    func testResolverStaysEnabledWhenActiveIsReplaced() {
        let settings = DNSSettings()
        settings.active = DoHConfig.presets[0].makeSettings()
        settings.resolverEnabled = true

        settings.active = DoHConfig.presets[1].makeSettings()

        XCTAssertTrue(settings.resolverEnabled)
    }
}
