//
//  PhotoPreview.swift
//  Croqet
//
//  Created by Agnetta Indira Revata on 05/05/26.
//

import SwiftUI
import AVFoundation

struct PhotoPreviewView: View {
    @State private var showResult = false
    
    let item: IdentifiableImage
    let onDismiss: () -> Void
    
    var body: some View {
        VStack{
            HStack{
                Button("Retake"){
                    onDismiss()
                }
                .padding()
                
                Spacer()
                
                Button("Save"){ // save to photos
                    showResult = true
                    // UIImageWriteToSavedPhotosAlbum(item.image, nil, nil, nil)
                    // onDismiss()
                }.padding()
                
            }
            .background(.ultraThinMaterial)
            
            Image(uiImage: item.image)
                .resizable()
                .scaledToFit()
            
            Spacer()
        }.fullScreenCover(isPresented: $showResult) {
            ResultScreen(inputImage: item.image)
        }
    }
    
}
