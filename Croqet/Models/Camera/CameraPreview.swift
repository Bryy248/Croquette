//
//  CameraPreview.swift
//  Croqet
//
//  Created by Agnetta Indira Revata on 04/05/26.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white // can be changed(?)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        // previewLayer.videoGravity = .resizeAspectFill
        previewLayer.videoGravity = .resizeAspect // so preview matched capture
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        
        // store layer in context
        
        context.coordinator.previewLayer = previewLayer
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = context.coordinator.previewLayer {
            DispatchQueue.main.async {
                previewLayer.frame = uiView.bounds
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator() // stores preview layers
    }
    
    class Coordinator {
        var previewLayer: AVCaptureVideoPreviewLayer?
    }
    
}
