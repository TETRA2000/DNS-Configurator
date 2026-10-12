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
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var dnsSettings = DNSSettings()
    @State private var wasInBackground = false
    
    var body: some View {
        Group {
            layout
        }
        .onAppear {
            Task { await dnsSettings.loadDoH() }
        }
        .onChange(of: scenePhase) { _, newPhase in
            // Reload only when returning from the background (e.g. after changing
            // the resolver in Settings), not on every inactive -> active transition.
            switch newPhase {
            case .background:
                wasInBackground = true
            case .active where wasInBackground:
                wasInBackground = false
                Task { await dnsSettings.loadDoH() }
            default:
                break
            }
        }
    }

    @ViewBuilder
    private var layout: some View {
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
                List {
                    NavigationLink(destination: DoHConfigListView().environmentObject(dnsSettings)) {
                        Label("DNS Server", systemImage: "list.dash")
                    }
                    NavigationLink(destination: DoHStatusView().environmentObject(dnsSettings)) {
                        Label("Status", systemImage: "waveform.path")
                    }
                    NavigationLink(destination: OptionsView().environmentObject(dnsSettings)) {
                        Label("Extras", systemImage: "wrench.fill")
                    }
                }
                
                Text("Select an option")
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
