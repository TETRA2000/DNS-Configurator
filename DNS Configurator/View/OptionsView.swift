//
//  OptionsView.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/21.
//

import SwiftUI

struct OptionsView: View {
    private enum RemovalAlert {
        case activeSetting
        case confirmRemoval

        var title: LocalizedStringKey {
            switch self {
            case .activeSetting: return "Can't remove active setting"
            case .confirmRemoval: return "Confirmation"
            }
        }

        var message: LocalizedStringKey {
            switch self {
            case .activeSetting: return "Please select another DNS provider in Setting app."
            case .confirmRemoval: return "Are you sure to remove the resolver setting?"
            }
        }
    }

    @State private var removalAlert: RemovalAlert?

    private var isShowingRemovalAlert: Binding<Bool> {
        Binding(
            get: { removalAlert != nil },
            set: { if !$0 { removalAlert = nil } }
        )
    }
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
                        .alert(
                            removalAlert?.title ?? "",
                            isPresented: isShowingRemovalAlert,
                            presenting: removalAlert
                        ) { alert in
                            switch alert {
                            case .activeSetting:
                                Button("OK", role: .cancel) {}
                            case .confirmRemoval:
                                Button("Remove", role: .destructive) {
                                    Task { await dnsSettings.removeDoH() }
                                }
                                Button("Cancel", role: .cancel) {}
                            }
                        } message: { alert in
                            Text(alert.message)
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
