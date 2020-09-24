//
//  ContentView.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/20.
//

import SwiftUI
import NetworkExtension

struct ContentView: View {
    var dnsSettings = DNSSettings()
    var body: some View {
        TabView {
            DoHConfigListView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("DNS Server")
                }
                .environmentObject(dnsSettings)
            
            DoHStatusView()
                .tabItem {
                    Image(systemName: "waveform.path")
                    Text("Status")
                }
                .environmentObject(dnsSettings)
            
            OptionsView()
                .tabItem {
                    Image(systemName: "wrench.fill")
                    Text("Extras")
                }
                .environmentObject(dnsSettings)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
