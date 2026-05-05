//
//  CameraView.swift
//  Croqet
//
//  Created by Agnetta Indira Revata on 05/05/26.
//

import SwiftUI
import AVFoundation // for camera
import AVKit // for camera
import SwiftData

struct CameraView: View {
    @StateObject private var cameraManager = CameraManager() // camera init
    @Binding var showCamera: Bool
    let project: ProjectData
    let rowIndex: Int
    
    var body: some View {
        // camera init start
        ZStack(alignment: .bottom) {
            if cameraManager.authorizationStatus == .authorized {
                CameraPreview(session: cameraManager.session)
                    .ignoresSafeArea()
            } else {
                VStack {
                    Image(systemName: "camera.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                    Text("Camera Access Required")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                    
                    if cameraManager.authorizationStatus == .denied {
                        Text("Please enable camera in settings.")
                        
                        Button("Open Settings") {
                            if let settingsURL = URL(string:
                                                        UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(settingsURL)
                            }
                        }
                        .buttonStyle(.borderedProminent) // maybe can be changed
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
            }
            
            // Capture Button
            Button {
                cameraManager.capturePhoto()
            } label: {
                Circle()
                    .strokeBorder(.white, lineWidth: 3) // can be changed
                    .frame(width: 70, height: 70)
                    .overlay {
                        Circle()
                            .fill(.white)
                            .frame(width: 60, height: 60)
                    }
                    .shadow(color: .black.opacity(0.4), radius: 4)
            }
            .padding(.bottom, 40)
        }
        .onAppear { cameraManager.checkAuthorization() } // camera shit
        .sheet(item: $cameraManager.capturedImage) { item in
            PhotoPreviewView(showCamera: $showCamera, item: item, onDismiss: {
                cameraManager.capturedImage = nil // clear image whenever dismissed
            }, project: project, rowIndex: rowIndex)
        }
    }
    
    //    var body: some View {
    //        // camera init start
    //
    //        ZStack{
    //
    //            if cameraManager.authorizationStatus == .authorized {
    //                CameraPreview(session: cameraManager.session)
    //                    .ignoresSafeArea()
    //            } else {
    //                VStack{
    //                    Image(systemName: "camera.fill")
    //                        .font(.largeTitle)
    //                        .foregroundStyle(.white)
    //                    Text("Camera Access Required")
    //                        .font(.largeTitle)
    //                        .foregroundStyle(.white)
    //
    //                    if cameraManager.authorizationStatus == .denied{
    //                        Text("Please enable camera in settings.")
    //
    //                        Button("Open Settings"){
    //                            if let settingsURL = URL(string: UIApplication.openSettingsURLString){
    //                                UIApplication.shared.open(settingsURL)
    //                            }
    //                        }
    //                        .buttonStyle(.borderedProminent) // maybe can be changed
    //                    }
    //                }
    //            }
    //
    //            VStack {
    //                Spacer()
    //
    //                // Capture Button
    //                Button {
    //                    cameraManager.capturePhoto()
    //                } label: {
    //                    Circle()
    //                        .strokeBorder(.white, lineWidth: 3) // can be changed
    //                        .frame(width: 70, height: 70)
    //                        .overlay {
    //                            Circle()
    //                                .fill(.white)
    //                                .frame(width: 60, height: 60)
    //                        }
    //
    //                }
    //                .padding(.bottom, 40)
    //
    //
    //            }.onAppear{
    //                cameraManager.checkAuthorization() // camera shit
    //            }.sheet(item: $cameraManager.capturedImage) { item in
    //                PhotoPreviewView(showCamera: $showCamera, item: item, onDismiss: {
    //                    cameraManager.capturedImage = nil // clear image whenever dismissed
    //                })
    //            }
    //
    //
    //
    //
    //        }
    //
    //
    //
    //
    //    }
}
