//
//  ResultScreen.swift
//  Croqet
//
//  Created by Sayyidah Fatimah Azzahra on 05/05/26.
//

import SwiftUI

struct ResultScreen:View {
    @State private var selectedView = ""
    @State private var stitchCounterText = "You have made: 24/24 stitches"
    @State private var nextHoleFinderText = "Your next hole is pointed out by the red arrow."
    
    let views = ["Stitch Counter", "Next Hole Finder"]
    
    var body: some View {
        VStack {
            Picker("Selected View", selection: $selectedView) {
                ForEach(views, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Spacer()
        }
        
        VStack {
            // image + overlay
            
            if selectedView == views[0] {
                Text(stitchCounterText)
            } else {
                Text(nextHoleFinderText)
            }
            
            Spacer()
        }
        .padding(50)
        .multilineTextAlignment(.center)
        
        // row dropdown
        
        NavigationLink(destination: ContentView()) {
            Text("Back to Projects")
        }
        Spacer()
    }
}

#Preview {
    ResultScreen()
}
