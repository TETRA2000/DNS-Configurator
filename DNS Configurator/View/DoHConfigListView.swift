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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var dnsSettings: DNSSettings
    @State var showingUsage = false
    
    var body: some View {
        let content = VStack{
            Text("Select a DNS server to use.")
                .font(.headline)
                .padding(.top)

            List(self.configurations, id: \.servers) { config in
                NavigationLink(destination: DoHConfigDetailView(config: config).environmentObject(dnsSettings)) {
                    Text(config.displayText)
                }
            }
            VStack(alignment: .leading){
                if dnsSettings.active != nil && !dnsSettings.resolverEnabled {
                    Text("The resolver is inactive.")
                        .fontWeight(.bold)
                        .foregroundColor(Color.red)
                        .padding(.top)
                    Button(action: {
                        showingUsage.toggle()
                    }, label: {
                        Text("How to activate?")
                    }).sheet(isPresented: $showingUsage) {
                        UsageModalView(showingUsage: $showingUsage)
                    }
                } else if dnsSettings.active == nil {
                    Text("No resolver is selected.")
                }
            }.padding(.bottom)
        }.padding(.bottom).navigationBarTitle("DNS Server")

        if horizontalSizeClass == .compact {
            NavigationView {
                content
            }.onAppear(perform: {
                self.dnsSettings.loadDoH()
            }).onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                self.dnsSettings.loadDoH()
            }
        } else {
            content
            .onAppear(perform: {
                self.dnsSettings.loadDoH()
            }).onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                self.dnsSettings.loadDoH()
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
