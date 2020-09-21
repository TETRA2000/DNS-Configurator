//
//  UsageModalView.swift
//  DNS Configurator
//
//  Created by Takahiko Inayama on 2020/09/21.
//

import SwiftUI

struct UsageModalView: View {
    @Binding var showingUsage: Bool

    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                Text("1. Open Settings App.")
                    .padding(.bottom)
                Text("2. Navigate to \"General\" -> \"VPN & Network\" -> \"DNS\".").lineLimit(nil).padding(.bottom)
                Text("3. Select \"DNS Configurator\".")
                    .padding(.bottom)
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
            Button(action: {showingUsage.toggle()}, label: {
                Text("Dismiss")
            })
            .padding(.top)
        }
    }
}


struct UsageModalView_Previews: PreviewProvider {
    @State static var showingUsage = true
    static var previews: some View {
        UsageModalView(showingUsage: $showingUsage)
    }
}
