//
//  DoHStatusView.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/21.
//

import SwiftUI
import NetworkExtension

struct DoHStatusView: View {
    @EnvironmentObject var dnsSettings: DNSSettings

    var body: some View {
        VStack {
            if let activeSettings = dnsSettings.active,
               let serverURL = activeSettings.serverURL
            {
                let servers = activeSettings.servers
                let config = DoHConfig(servers: servers, serverURL: serverURL.absoluteString, displayText: "")
                
                Text("Current Configuration")
                    .font(.headline)
                DoHConfigView(config: config)
            } else {
                Text("No DNS server selected.")
                    .foregroundColor(.gray)
            }
        }
    }
}

struct DoHStatusView_Previews: PreviewProvider {
    static var previews: some View {
        DoHStatusView()
            .environmentObject(DNSSettings())
    }
}
