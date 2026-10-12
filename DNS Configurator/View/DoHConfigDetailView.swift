//
//  DoHConfigDetailView.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/20.
//

import SwiftUI

struct DoHConfigDetailView: View {
    let config: DoHConfig
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var dnsSettings: DNSSettings

    var body: some View {
        VStack {
            DoHConfigView(config: config)
            Button("Select this server") {
                Task {
                    await dnsSettings.applyDoH(config: config)
                }
                presentationMode.wrappedValue.dismiss()
            }
        }
        .padding(.bottom)
        .navigationTitle(config.displayText)
    }
}

struct DoHConfigDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DoHConfigDetailView(config: DoHConfig.presets[1])
            .environmentObject(DNSSettings())
    }
}
