//
//  ContentView.swift
//  Croquette
//
//  Created by Brian Chang on 27/04/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack (spacing: 16){
            HStack () {
                Image(systemName: "star")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hi Mia!")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Projects")
                    .bold()
                    .font(.system(size: 32))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(16)
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
