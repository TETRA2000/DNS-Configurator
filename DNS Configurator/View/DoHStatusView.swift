//
//  DoHStatusView.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/21.
//

import SwiftUI
import NetworkExtension

struct DoHStatusView: View {
    @State var dnsSettings: NEDNSOverHTTPSSettings?

    var body: some View {
        VStack {
            if let dnsSettings = dnsSettings,
               let servers = dnsSettings.servers,
               let serverURL = dnsSettings.serverURL
            {
                let config = DoHConfig(servers: servers, serverURL: serverURL.absoluteString, displayText: "")
                
                Text("Current Configuration")
                    .font(.headline)
                DoHConfigView(config: config)
            }
        }.onAppear(perform: {
          loadDoH()
        })
    }
    
    func loadDoH() {
        NEDNSSettingsManager.shared().loadFromPreferences { loadError in

            
            if let loadError = loadError {
                print(loadError)
                return
            }

            
            if let dnsSettings = NEDNSSettingsManager.shared().dnsSettings as? NEDNSOverHTTPSSettings {
                self.dnsSettings = dnsSettings
                
                print("ok")
                print(NEDNSSettingsManager.shared().isEnabled)
            }
        }
    }
}


struct DoHStatusView_Previews: PreviewProvider {
    static var previews: some View {
        DoHStatusView()
    }
}
