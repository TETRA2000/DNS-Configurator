//
//  DoHConfigView.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/20.
//

import SwiftUI
import NetworkExtension

struct DoHConfigDetailView: View {
    let config: DoHConfig
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            DoHConfigView(config: config)
            Button(action: {
                applyDoH(config: config)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Select this server")
            })
        }.padding(.bottom).navigationBarTitle(config.displayText)
    }
    
    func applyDoH(config: DoHConfig) {
        NEDNSSettingsManager.shared().loadFromPreferences { loadError in            
            if let loadError = loadError {
                print(loadError)
                return
            }
            let dohSettings = NEDNSOverHTTPSSettings(servers: config.servers)
            dohSettings.serverURL = URL(string: config.serverURL)
            
            NEDNSSettingsManager.shared().dnsSettings = dohSettings
            NEDNSSettingsManager.shared().saveToPreferences { saveError in
                if let saveError = saveError {
                    print(saveError.localizedDescription)
                    return
                }
                
                print("ok")
                print(NEDNSSettingsManager.shared().isEnabled)
            }
        }
    }
}


struct DoHConfigDetailView_Previews: PreviewProvider {
    @State static var selectedConfig: DoHConfig?
    static var previews: some View {
        DoHConfigDetailView(config: DoHConfig(servers:  [ "8.8.8.8", "8.8.4.4", "2001:4860:4860::8888", "2001:4860:4860::8844" ], serverURL: "https://cloudflare-dns.com/dns-query", displayText: "Google Public DNS"))
    }
}
