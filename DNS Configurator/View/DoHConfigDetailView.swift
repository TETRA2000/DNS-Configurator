//
//  DoHConfigView.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/20.
//

import SwiftUI

struct DoHConfigDetailView: View {
    let config: DoHConfig
    @Binding var selectedConfig: DoHConfig?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            DoHConfigView(config: config)
            Button(action: {
                selectedConfig = config
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Use this server")
            })
        }.padding(.bottom).navigationBarTitle(config.displayText)

    }
}


struct DoHConfigDetailView_Previews: PreviewProvider {
    @State static var selectedConfig: DoHConfig?
    static var previews: some View {
        DoHConfigDetailView(config: DoHConfig(servers:  [ "8.8.8.8", "8.8.4.4", "2001:4860:4860::8888", "2001:4860:4860::8844" ], serverURL: "https://cloudflare-dns.com/dns-query", displayText: "Google Public DNS"), selectedConfig: $selectedConfig)
    }
}
