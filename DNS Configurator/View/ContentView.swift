//
//  ContentView.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/20.
//

import SwiftUI
import NetworkExtension

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var dnsSettings = DNSSettings()
    var body: some View {
        if horizontalSizeClass == .compact {
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
        } else {
            NavigationView {
                List() {
                    NavigationLink(destination: DoHConfigListView().environmentObject(dnsSettings)) {
                        Text("DNS Server")
                    }
                    NavigationLink(destination: DoHStatusView().environmentObject(dnsSettings)) {
                        Text("Status")
                    }
                    NavigationLink(destination: OptionsView().environmentObject(dnsSettings)) {
                        Text("Extras")
                    }
                }
            }.navigationBarHidden(false)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
