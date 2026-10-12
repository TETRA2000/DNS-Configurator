//
//  DNS_ConfiguratorUITests.swift
//  DNS ConfiguratorUITests
//
//  Created by Takahiko Inayama on 2020/09/20.
//

import XCTest

// These tests avoid tapping "Select this server" because it writes the
// system DNS settings and would leak state between runs.
class DNS_ConfiguratorUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Helpers

    // Opens a top-level section through the tab bar (compact) or the sidebar (regular).
    private func openSection(_ title: String) {
        let tab = app.tabBars.buttons[title]
        if tab.exists {
            tab.tap()
        } else {
            app.buttons[title].firstMatch.tap()
        }
    }

    private func waitFor(_ element: XCUIElement, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(element.waitForExistence(timeout: 5), "\(element) did not appear", file: file, line: line)
    }

    // MARK: - DNS Server

    func testServerListShowsPresets() {
        openSection("DNS Server")

        waitFor(app.staticTexts["Select a DNS server to use."])
        XCTAssertTrue(app.buttons["Cloudflare DNS"].exists)
        XCTAssertTrue(app.buttons["Google Public DNS"].exists)
    }

    func testServerDetailShowsServersAndQueryURL() {
        openSection("DNS Server")
        waitFor(app.buttons["Cloudflare DNS"])

        app.buttons["Cloudflare DNS"].tap()

        waitFor(app.navigationBars["Cloudflare DNS"])
        XCTAssertTrue(app.staticTexts["1.1.1.1"].exists)
        XCTAssertTrue(app.staticTexts["2606:4700:4700::1111"].exists)
        XCTAssertTrue(app.staticTexts["https://cloudflare-dns.com/dns-query"].exists)
        XCTAssertTrue(app.buttons["Select this server"].exists)
    }

    func testServerDetailBackReturnsToList() {
        openSection("DNS Server")
        waitFor(app.buttons["Google Public DNS"])

        app.buttons["Google Public DNS"].tap()
        waitFor(app.navigationBars["Google Public DNS"])
        app.navigationBars.buttons.firstMatch.tap()

        waitFor(app.staticTexts["Select a DNS server to use."])
    }

    // There's no Home button to press on Mac Catalyst.
    #if !targetEnvironment(macCatalyst)
    func testServerListStillWorksAfterReturningFromBackground() {
        openSection("DNS Server")
        waitFor(app.buttons["Cloudflare DNS"])

        // Backgrounding triggers a settings reload; the list must stay usable.
        XCUIDevice.shared.press(.home)
        app.activate()

        waitFor(app.buttons["Cloudflare DNS"])
        app.buttons["Cloudflare DNS"].tap()
        waitFor(app.navigationBars["Cloudflare DNS"])
    }
    #endif

    // MARK: - Status / Extras

    func testStatusWithoutResolver() throws {
        openSection("DNS Server")
        try XCTSkipIf(app.staticTexts["No resolver is selected."].waitForExistence(timeout: 5) == false,
                      "A resolver is already configured on this device")

        openSection("Status")

        waitFor(app.staticTexts["No DNS server selected."])
    }

    func testExtrasWithoutResolver() throws {
        openSection("DNS Server")
        try XCTSkipIf(app.staticTexts["No resolver is selected."].waitForExistence(timeout: 5) == false,
                      "A resolver is already configured on this device")

        openSection("Extras")

        waitFor(app.staticTexts["No options available."])
        XCTAssertFalse(app.buttons["Remove the resolver setting"].exists)
        XCTAssertTrue(app.buttons["Source Code (github.com)"].exists)
    }

    // MARK: - Performance

    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
