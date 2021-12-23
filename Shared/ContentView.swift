//
//  ContentView.swift
//  Shared
//
//  Created by Matheus Gois on 21/12/21.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        Text("Hello, world!")
            .padding()
            .onTapGesture {
                BiometricHandler.authenticate(reason: "Reason") { success, code in
                    print(success, code)
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
