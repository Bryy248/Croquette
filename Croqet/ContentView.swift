//
//  ContentView.swift
//  Croquette
//
//  Created by Brian Chang on 27/04/26.
//

import SwiftUI

// Temporary Model
struct TemporaryProject: Identifiable {
    let id = UUID()
    var name: String
}

struct ContentView: View {
    // Temporary
    @State private var projects: [TemporaryProject] =  [TemporaryProject(name: "tapak")]
    // []
    
    var body: some View {
        ZStack() {
            // Background Color Layer
            Color.backgroundMint
                .ignoresSafeArea()
            
            // Second Layer
            VStack (spacing: 16) {
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
                        .font(.system(size: 36))
                    
                    if projects.isEmpty {
                        Text("No existing project.")
                            .fontWeight(.semibold)
                            .font(Font.system(size: 16))
                            .foregroundStyle(.gray)
                    }
                    else {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(projects) { project in
                                HistoryCard()
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                if projects.isEmpty {
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
