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
    @EnvironmentObject var dnsSettings: DNSSettings
    @State var resolverEnabled: Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Select DNS server to use.")
                    .font(.headline)
                    .padding(.top)

                List(self.configurations, id: \.servers) { config in
                    NavigationLink(destination: DoHConfigDetailView(config: config)) {
                        Text(config.displayText)
                    }
                }
                VStack(alignment: .leading){
                    if dnsSettings.active != nil && !resolverEnabled {
                        Text("Resolver is inactive.")
                            .fontWeight(.bold)
                            .foregroundColor(Color.red)
                            .padding(.top)
                        Button(action: {}, label: {
                            Text("How to activate?")
                        })
                    } else if dnsSettings.active == nil {
                        Text("No resolver is selected.")
                    }
                }.padding(.bottom)
            }.padding(.bottom).navigationBarTitle("DNS Server")
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
                self.resolverEnabled = NEDNSSettingsManager.shared().isEnabled
            } else {
                self.dnsSettings.active = nil
            }
        }
    }
}

struct DoHConfigListView_Previews: PreviewProvider {
    static let dnsSettings = DNSSettings()
    static var previews: some View {
        DoHConfigListView().environmentObject(dnsSettings)
    }
}
