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
                    Text("DoH Config")
                }
            
            OptionsView()
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
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
