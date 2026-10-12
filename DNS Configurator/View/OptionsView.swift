//
//  OptionsView.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/21.
//

import SwiftUI

struct OptionsView: View {
    private enum RemovalAlert: Identifiable {
        case activeSetting
        case confirmRemoval

        var id: Self { self }
    }

    @State private var removalAlert: RemovalAlert?
    @EnvironmentObject var dnsSettings: DNSSettings
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack {
            Text("Extras")
                .font(.headline)
            List {
                Section(header: Text("Options")) {
                    if dnsSettings.active != nil {
                        Button(action: { validateToRemoveDoH() }) {
                            Text("Remove the resolver setting")
                                .foregroundColor(.red)
                        }
                        .alert(item: $removalAlert) { alert in
                            switch alert {
                            case .activeSetting:
                                return Alert(
                                    title: Text("Can't remove active setting"),
                                    message: Text("Please select another DNS provider in Setting app."),
                                    dismissButton: .default(Text("OK"))
                                )
                            case .confirmRemoval:
                                return Alert(
                                    title: Text("Confirmation"),
                                    message: Text("Are you sure to remove the resolver setting?"),
                                    primaryButton: .destructive(Text("Remove")) {
                                        Task { await dnsSettings.removeDoH() }
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                        }
                    } else {
                        Text("No options available.")
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("About This App")) {
                    Button("Source Code (github.com)") {
                        if let url = URL(string: "https://github.com/TETRA2000/DNS-Configurator") {
                            openURL(url)
                        }
                    }
                }
            }
        }
    }

    func validateToRemoveDoH() {
        Task {
            // Refresh first so the decision uses the current enabled state from Settings.
            await dnsSettings.loadDoH()
            guard dnsSettings.active != nil else { return }
            removalAlert = dnsSettings.resolverEnabled ? .activeSetting : .confirmRemoval
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
            .environmentObject(DNSSettings())
    }
}
