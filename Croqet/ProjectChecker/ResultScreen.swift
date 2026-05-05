//
//  ResultScreen.swift
//  Croqet
//
//  Created by Sayyidah Fatimah Azzahra on 05/05/26.
//

import SwiftUI

struct ResultScreen:View {
    @State private var selectedView = ""
    @State private var stitchCounterText = "Lorem ipsum dolor sit amet."
    @State private var nextHoleFinderText = "Lorem ipsum dolor sit amet."
    @State private var overlayImage: UIImage?
    
    let views = ["Stitch Counter", "Next Hole Finder"]
    let inputImage: UIImage
    
    var body: some View {
        VStack(spacing: 20) {
            Picker("Selected View", selection: $selectedView) {
                ForEach(views, id: \.self) { Text($0) }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top, 30)
            
            Spacer()
            
            if let overlayImage {
                Image(uiImage: overlayImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
            } else {
            }
            
            Text(selectedView == views[0] ? stitchCounterText : nextHoleFinderText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
            
            Spacer()
            
            Text("Back to Projects")
                .padding(.bottom, 30)
        }
        .task {
            overlayImage = await runCrochetDetection(image: inputImage)
        }
    }
}

#Preview {
    ResultScreen(inputImage: UIImage(named:"") ?? UIImage())
}
