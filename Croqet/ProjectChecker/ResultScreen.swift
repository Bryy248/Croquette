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
    @State private var overlayImage: UIImage?
    
    let views = ["Stitch Counter", "Next Hole Finder"]
    
    var body: some View {
        VStack(spacing: 20) {
            Picker("Selected View", selection: $selectedView) {
                ForEach(views, id: \.self) { Text($0) }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top, 30)
            
            Spacer()
            
            // Image(uiImage: overlayImage)
            Image("test_crochet_1")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            
            Text(selectedView == views[0] ? stitchCounterText : nextHoleFinderText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
            
            Spacer()
            
            Text("Back to Projects")
                .padding(.bottom, 30)
        }
        .task {
            overlayImage = await runCrochetDetection()
        }
    }
}

#Preview {
    ResultScreen()
}
