//
//  ContentView.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/20.
//

import SwiftUI
import NetworkExtension

struct ContentView: View {
    var body: some View {
        TabView {
            DoHConfigListView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("DNS Server")
                }
            
            DoHStatusView()
                .tabItem {
                    Image(systemName: "waveform.path")
                    Text("Status")
                }
            
            OptionsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Options")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
