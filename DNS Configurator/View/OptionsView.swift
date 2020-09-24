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
    @State var showRemovalAlert = false {
        didSet {
            showAlert = showRemovalAlert || showActiveAlert
        }
    }
    @State var showActiveAlert = false {
        didSet {
            showAlert = showRemovalAlert || showActiveAlert
        }
    }
    @EnvironmentObject var dnsSettings: DNSSettings
    
    var body: some View {
        VStack {
            Text("Extras")
                .font(.headline)
            List {
                Section(header: Text("Options")) {
                    if (dnsSettings.active != nil) {
                        Button(action: {validateToRemoveDoH()}) {
                            Text("Remove the resolver setting")
                                .foregroundColor(Color.red)
                        }
                        .alert(isPresented: $showAlert) {
                            if (showActiveAlert) {
                                return Alert(
                                    title: Text("Can't remove active setting"),
                                    message: Text("Please select another DNS provider in Setting app.")
                                )
                            } else {
                                return Alert(
                                    title: Text("Confirmation"),
                                    message: Text("Are you sure to remove the resolver setting?"),
                                    primaryButton: .destructive(Text("Remove"), action: {dnsSettings.removeDoH()}),
                                    secondaryButton: .cancel(Text("Cancel"), action: {showRemovalAlert.toggle()})
                                )
                            }
                        }
           
                    } else {
                        Text("No options available.")
                            .foregroundColor(Color.gray)
                    }
                }
                
                Section(header: Text("About This App")) {
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://github.com/TETRA2000/DNS-Configurator")!)
                    }, label: {
                        Text("Source Code (github.com)")
                    })
                }
            }
        }
    }

    func validateToRemoveDoH() {
        NEDNSSettingsManager.shared().loadFromPreferences { loadError in
            if let loadError = loadError {
                print(loadError)
                return
            }
            
            showActiveAlert = NEDNSSettingsManager.shared().isEnabled
            if !showActiveAlert {
                showRemovalAlert = true
            }
        }
    }
}


struct OptionsView_Previews: PreviewProvider {
    static let dnsSettings = DNSSettings()
    static var previews: some View {
        OptionsView().environmentObject(dnsSettings)
    }
}
