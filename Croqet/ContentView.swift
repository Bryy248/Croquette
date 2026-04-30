//
//  ContentView.swift
//  Croquette
//
//  Created by Brian Chang on 27/04/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack() {
            // Background Color Layer
            Color.backgroundMint
            
            // Second Layer
            VStack (spacing: 16) {
                HStack () {
                    Image(systemName: "star")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hi Mia!")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                VStack(spacing: 16) {
                    Text("Projects")
                        .bold()
                        .font(.system(size: 36))
                    Text("No existing project.")
                        .fontWeight(.semibold)
                        .font(Font.system(size: 16))
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    Text("What are you making?")
                        .fontWeight(.semibold)
                        .font(Font.system(size: 24))
                        .foregroundStyle(.primary)
                    
                    CroqetButton(title: "Add Project") {
                    }
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(16)
            
            
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity)
        
    }
}

#Preview {
    ContentView()
}
