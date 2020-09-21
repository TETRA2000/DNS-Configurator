//
//  DoHConfigView.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/21.
//

import SwiftUI

struct DoHConfigView: View {
    let config: DoHConfig
    
    var body: some View {
        List {
            Section(header: Text("Servers")) {
                ForEach(config.servers, id: \.hashValue) { server in
                    Text(server)
                }
            }
            
            Section(header: Text("Query URL")) {
                Text(config.serverURL)
            }
        }
    }
}


struct DoHConfiglView_Previews: PreviewProvider {
    @State static var selectedConfig: DoHConfig?
    static var previews: some View {
        DoHConfigView(config: DoHConfig(servers:  [ "8.8.8.8", "8.8.4.4", "2001:4860:4860::8888", "2001:4860:4860::8844" ], serverURL: "https://cloudflare-dns.com/dns-query", displayText: "Google Public DNS"))
    }
}
