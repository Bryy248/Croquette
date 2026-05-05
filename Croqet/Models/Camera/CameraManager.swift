//
//  CameraManager.swift
//  Croqet
//
//  Created by Agnetta Indira Revata on 04/05/26.
//

// https://youtu.be/ik1QRc_kN9M?si=bHhztGLnpR3SwAUP

// device -> input -> session -> output -> your app

import AVFoundation
import SwiftUI
import Combine

class CameraManager: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    
    @Published var capturedImage: IdentifiableImage? // optional
    @Published var isSessionRunning = false
    @Published var authorizationStatus: AVAuthorizationStatus = .notDetermined
    
    // AVFoundation Components
    let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
//    private let videoOuput = AVCaptureMovieFileOutput()
    private var currentInput: AVCaptureDeviceInput?
    
    private let sessionQueue = DispatchQueue(label: "com.customcamera.sessionQueue")
    
    override init() {
        super.init()
    }
    
    func checkAuthorization(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized:
            authorizationStatus = .authorized
            setupSession()
            
        case .notDetermined:
            authorizationStatus = .notDetermined
            AVCaptureDevice.requestAccess(for: .video) {
                [weak self] granted in DispatchQueue.main.async{
                    self?.authorizationStatus = granted ? .authorized : .denied
                    if granted {
                        self?.setupSession()
                    }
                }
            }
            
        case .denied, .restricted:
            authorizationStatus = .denied
            
        @unknown default:
            authorizationStatus = .denied
            
        }
        
    }
    
    // Configure AVSetup
    
    private func setupSession(){
        sessionQueue.async {
            [weak self] in
            guard let self = self else {return}
            guard !self.session.isRunning && self.currentInput == nil else { return }

            // set session preset
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo

            // camera input -> standard rear camera
            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back), let input = try? AVCaptureDeviceInput(device: camera) else {
                print("Failed to access camera.")
                self.session.commitConfiguration()
                return
            }

            if self.session.canAddInput(input) {
                self.session.addInput(input)
                self.currentInput = input
            }

            // add photo output
            if self.session.canAddOutput(self.photoOutput){
                self.session.addOutput(self.photoOutput)
            }

            self.session.commitConfiguration() // -> all changes at once

            // start the session
            self.session.startRunning()

            DispatchQueue.main.async {
                self.isSessionRunning = self.session.isRunning
            }

        }
    }
    
    
    // capturing the actual image
    func capturePhoto() {
        sessionQueue.async {
            [weak self] in
            guard let self = self else { return }
            
            
            // config photo settings
            let settings = AVCapturePhotoSettings()
            settings.flashMode = .auto

            self.photoOutput.capturePhoto(with: settings, delegate: self)
            
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Photo capture error \(error.localizedDescription)")
            return
        }
        
        // extract image data
        guard let imageData = photo.fileDataRepresentation(),
              let uiImage = UIImage(data: imageData) else {
            print("Failed to convert photo to image")
            return
        }
        
        // update UI on main thread
        DispatchQueue.main.async {
            [weak self] in
            self?.capturedImage = IdentifiableImage(image: uiImage)
        }
        
        
    }
    
}




struct IdentifiableImage: Identifiable{
    let id = UUID()
    let image: UIImage
}
