//
//  OptionsView.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/21.
//

import SwiftUI
import NetworkExtension

struct OptionsView: View {
    @State var showAlert = false
    @EnvironmentObject var dnsSettings: DNSSettings
    
    var body: some View {
        VStack {
            if (dnsSettings.active != nil) {
                Button(action: {removeDoH()}) {
                    Text("Remove DNS resolver setting")
                        .foregroundColor(Color.red)
                }
                .disabled(dnsSettings.active == nil)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Can't remove active config"),
                        message: Text("Please select another DNS provider in Setting app.")
                    )
                }
            } else {
                Text("No option available.")
                    .foregroundColor(Color.gray)
            }
        }
    }

    func removeDoH() {
        NEDNSSettingsManager.shared().loadFromPreferences { loadError in
            if let loadError = loadError {
                print(loadError)
                return
            }
            
            if NEDNSSettingsManager.shared().isEnabled {
                showAlert = true
                return
            }
            
            dnsSettings.removeDoH()
        }
    }
}


struct OptionsView_Previews: PreviewProvider {
    static let dnsSettings = DNSSettings()
    static var previews: some View {
        OptionsView().environmentObject(dnsSettings)
    }
}
