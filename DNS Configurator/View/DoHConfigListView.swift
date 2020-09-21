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
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Select DNS server to use.")
                List(self.configurations, id: \.servers) { config in
                    NavigationLink(destination: DoHConfigDetailView(config: config)) {
                        Text(config.displayText)
                    }
                }
            }.padding(.bottom).navigationBarTitle("DNS Server")
        }
    }
}

struct DoHConfigListView_Previews: PreviewProvider {
    static var previews: some View {
        DoHConfigListView()
    }
}
