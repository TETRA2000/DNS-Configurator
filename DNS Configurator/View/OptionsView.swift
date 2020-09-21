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
    
    var body: some View {
        VStack {
            Button(action: {removeDoH()}) {
                Text("Remove DNS resolver setting")
                    .foregroundColor(Color.red)
            }.alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Can't remove active config"),
                    message: Text("Please select another DNS provider in Setting app.")
                )
            }
        }
    }

    func removeDoH() {
        NEDNSSettingsManager.shared().loadFromPreferences { loadError in
            if let loadError = loadError {
                print(loadError)
                return
            }
            
            if NEDNSSettingsManager.shared().isEnabled {
                showAlert = true
                return
            }
            
            NEDNSSettingsManager.shared().removeFromPreferences(completionHandler: {
                removeError in
                // TODO
                if let removeError = removeError {
                    print(removeError.localizedDescription)
                    return
                }
            })
        }
    }
}


struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
