//
//  OptionsView.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/21.
//

import SwiftUI
import NetworkExtension

struct OptionsView: View {
    @State var showAlert = false
    @State var dnsSettings: NEDNSOverHTTPSSettings?
    
    var body: some View {
        VStack {
            if let dnsSettings = dnsSettings,
               let servers = dnsSettings.servers,
               let serverURL = dnsSettings.serverURL
            {
                let config = DoHConfig(servers: servers, serverURL: serverURL.absoluteString, displayText: "")
                
                Text("Current Configuration")
                    .font(.headline)
                DoHConfigView(config: config)
            }
            
            Button(action: {loadDoH()}) {
                Text("Reload")
            }
            
            Button(action: {removeDoH()}) {
                Text("Remove")
                    .foregroundColor(Color.red)
            }.alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Can't remove active config."),
                    message: Text("Please select another DNS provider in Setting app at first.")
                )
            }
        }
    }
    
    func loadDoH() {
        NEDNSSettingsManager.shared().loadFromPreferences { loadError in

            
            if let loadError = loadError {
                print(loadError)
                return
            }

            
            if let dnsSettings = NEDNSSettingsManager.shared().dnsSettings as? NEDNSOverHTTPSSettings {
                self.dnsSettings = dnsSettings
                
                print("ok")
                print(NEDNSSettingsManager.shared().isEnabled)
            }
        }
    }
    
    func removeDoH() {
        if NEDNSSettingsManager.shared().isEnabled {
            showAlert = true
            return
        }
        
        NEDNSSettingsManager.shared().removeFromPreferences(completionHandler: {
            removeError in
            // TODO
            if let removeError = removeError {
                print(removeError)
                return
            }
        })
    }
}


struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
