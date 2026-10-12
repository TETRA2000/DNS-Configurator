//
//  DoHConfigListView.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/21.
//

import SwiftUI
import NetworkExtension

struct DoHConfigListView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var dnsSettings: DNSSettings
    @State private var showingUsage = false
    
    var body: some View {
        let content = VStack {
            Text("Select a DNS server to use.")
                .font(.headline)
                .padding(.top)

            List(DoHConfig.presets) { config in
                NavigationLink(destination: DoHConfigDetailView(config: config).environmentObject(dnsSettings)) {
                    Text(config.displayText)
                }
            }
            VStack(alignment: .leading) {
                if dnsSettings.active != nil && !dnsSettings.resolverEnabled {
                    Text("The resolver is inactive.")
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .padding(.top)
                    Button("How to activate?") {
                        showingUsage.toggle()
                    }
                    .sheet(isPresented: $showingUsage) {
                        UsageModalView(showingUsage: $showingUsage)
                    }
                } else if dnsSettings.active == nil {
                    Text("No resolver is selected.")
                }
            }
            .padding(.bottom)
        }
        .padding(.bottom)
        .navigationTitle("DNS Server")

        if horizontalSizeClass == .compact {
            NavigationView {
                content
            }
        } else {
            content
        }
    }
}

struct DoHConfigListView_Previews: PreviewProvider {
    static var previews: some View {
        DoHConfigListView()
            .environmentObject(DNSSettings())
    }
}
