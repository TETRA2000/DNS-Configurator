//
//  ContentView.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/20.
//

import SwiftUI
import NetworkExtension

struct ContentView: View {
    var body: some View {
        VStack{
            Text("Hello, world!")
                .padding()
            Button(action: {
                print("hello!!")
                NEDNSSettingsManager.shared().loadFromPreferences { loadError in
                    if let loadError = loadError {
                        
                        return
                    }
//                    let dohSettings = NEDNSOverHTTPSSettings(servers: [ "8.8.8.8", "8.8.4.4", "2001:4860:4860::8888", "2001:4860:4860::8844" ])
//                    dohSettings.serverURL = URL(string: "https://dns.google/dns-query")
                    
                    let dohSettings = NEDNSOverHTTPSSettings(servers: [ "1.1.1.1", "1.0.0.1", "2606:4700:4700::1111", "2606:4700:4700::1001" ])
                    dohSettings.serverURL = URL(string: "https://cloudflare-dns.com/dns-query")
                    
                    NEDNSSettingsManager.shared().dnsSettings = dohSettings
                    NEDNSSettingsManager.shared().saveToPreferences { saveError in
                        if let saveError = saveError {
                            
                            return
                        }
                    }
                }
            }, label: {
                Text("Button")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
