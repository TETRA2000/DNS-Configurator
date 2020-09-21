//
//  DoHConfigListView.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/21.
//

import SwiftUI
import NetworkExtension

struct DoHConfigListView: View {
    @State private var configurations: Array<DoHConfig> = [
        DoHConfig(servers: [ "1.1.1.1", "1.0.0.1", "2606:4700:4700::1111", "2606:4700:4700::1001" ], serverURL: "https://cloudflare-dns.com/dns-query", displayText: "Cloudflare DNS"),
        DoHConfig(servers:  [ "8.8.8.8", "8.8.4.4", "2001:4860:4860::8888", "2001:4860:4860::8844" ], serverURL: "https://dns.google/dns-query", displayText: "Google Public DNS"),
    ]
    @State private var currentConfig: DoHConfig?
    @State private var selectedConfig: DoHConfig?

    
    var body: some View {
        NavigationView {
            VStack{
                List(self.configurations, id: \.servers) { config in
                    NavigationLink(destination: DoHConfigView(config: config, selectedConfig: $selectedConfig)) {
                        HStack {
                            if selectedConfig != nil &&
                                selectedConfig?.servers != currentConfig?.servers {
                                if selectedConfig?.servers == config.servers {
                                   Image(systemName: "info.circle.fill")
                                }
                            } else if currentConfig?.servers == config.servers {
                                Image(systemName: "checkmark")
                            }
                            Text(config.displayText)
                        }
                    }
                    
                }
                
                if selectedConfig != nil {
                    Text("Pending Update")
                        .fontWeight(.light)
                    Button(action: {
                        applyDoH()
                    }, label: {
                        Text("Apply")
                            .fontWeight(.semibold)
                    })
                }
            }.padding(.bottom).navigationBarTitle("DoH Configuration")
        }
    }
    
    func applyDoH() {
        NEDNSSettingsManager.shared().loadFromPreferences { loadError in
            guard let config = self.selectedConfig else {
                // TODO
                return
            }
            
            if let loadError = loadError {
                print(loadError)
                return
            }
            let dohSettings = NEDNSOverHTTPSSettings(servers: config.servers)
            dohSettings.serverURL = URL(string: config.serverURL)
            
            NEDNSSettingsManager.shared().dnsSettings = dohSettings
            NEDNSSettingsManager.shared().saveToPreferences { saveError in
                if let saveError = saveError {
                    print(saveError)
                    return
                }
                
                print("ok")
                print(NEDNSSettingsManager.shared().isEnabled)
                
                currentConfig = selectedConfig
                selectedConfig = nil
            }
        }
    }
}

struct DoHConfigListView_Previews: PreviewProvider {
    static var previews: some View {
        DoHConfigListView()
    }
}
