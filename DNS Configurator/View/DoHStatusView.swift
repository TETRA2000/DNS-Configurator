//
//  DoHStatusView.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/21.
//

import SwiftUI
import NetworkExtension

struct DoHStatusView: View {
    @EnvironmentObject var dnsSettings: DNSSettings

    var body: some View {
        VStack {
            if let dnsSettings = dnsSettings.active,
               let servers = dnsSettings.servers,
               let serverURL = dnsSettings.serverURL
            {
                let config = DoHConfig(servers: servers, serverURL: serverURL.absoluteString, displayText: "")
                
                Text("Current Configuration")
                    .font(.headline)
                DoHConfigView(config: config)
            } else {
                Text("No DNS server selected.")
            }
        }.onAppear(perform: {
          loadDoH()
        }).onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            loadDoH()
        }
    }
    
    func loadDoH() {
        NEDNSSettingsManager.shared().loadFromPreferences { loadError in
            if let loadError = loadError {
                print(loadError)
                self.dnsSettings.active = nil
                return
            }

            
            if let dnsSettings = NEDNSSettingsManager.shared().dnsSettings as? NEDNSOverHTTPSSettings {

                self.dnsSettings.active = dnsSettings
                self.dnsSettings.resolverEnabled = NEDNSSettingsManager.shared().isEnabled
            } else {
                self.dnsSettings.active = nil
            }
        }
    }
}


struct DoHStatusView_Previews: PreviewProvider {
    static let dnsSettings = DNSSettings()
    static var previews: some View {
        DoHStatusView().environmentObject(dnsSettings)
    }
}
