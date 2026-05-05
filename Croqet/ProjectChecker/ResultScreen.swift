//
//  ResultScreen.swift
//  Croqet
//
//  Created by Sayyidah Fatimah Azzahra on 05/05/26.
//

import SwiftUI
import SwiftData

struct ResultScreen:View {
    @State private var selectedView = "Stitch Counter"
    @State private var predictions: [[String: Any]] = []
    @State private var overlayImage: UIImage?
    @State private var isLoading = true
    @Binding var showCamera: Bool
    
    let views = ["Stitch Counter", "Next Hole Finder"]
    let inputImage: UIImage
    
    let project: ProjectData
    let rowIndex: Int
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("background_color")
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Picker("Selected View", selection: $selectedView) {
                        ForEach(views, id: \.self) { Text($0).font(.subheading) }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedView) { _, _ in updateOverlay() }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                    if let overlayImage {
                        Image(uiImage: overlayImage)
                              .resizable()
                              .scaledToFill()
                              .frame(width: 330, height: 320)
                              .clipped()
                              .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                              .allowsHitTesting(false)
                            .padding(.horizontal, 24)
                    }

                    Text(resultMessage)
                        .font(.subheading)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 50)
                        .fixedSize(horizontal: false, vertical: true)

                    if rowIndex < project.rows.count {
                        RowProgressCard(
                            rowNumber: rowIndex + 1,
                            length: project.length,
                            row: project.rows[rowIndex],
                            isEditable: false
                        )
                        .background(.white)
                        .cornerRadius(26)
                        .padding(.horizontal, 24)
                    }

                    Spacer(minLength: 0)

                    Button("Back to Project Details") {
                        showCamera = false
                    }
                    .font(.bodyText)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 30)
                }
                .opacity(isLoading ? 0 : 1)
                .overlay {
                    if isLoading {
                        VStack(spacing: 16) {
                            ProgressView().scaleEffect(1.4)
                            Text("Analyzing your crochet...")
                                .font(.subheading)
                        }
                    }
                }
                .task {
                    isLoading = true
                    
                    print("Running predictions")
                    predictions = await fetchPredictions(image: inputImage)
                    
                    updateOverlay()
                    if rowIndex < project.rows.count {
                        project.rows[rowIndex].progress = min(predictions.count, project.length)
                    }
                    
                    isLoading = false
                    print(predictions)
                    //            overlayImage = UIImage(named: "test_crochet_1")
                    //            predictions = []
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showCamera = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                }
            }
            .toolbarBackground(Color("background_color"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private var resultMessage: String {
        if isLoading {
            return "Analyzing your crochet..."
        }
        let count = predictions.count
        if selectedView == views[0] {
            if count == 0 {
                return "No stitches detected. Try better lighting or a closer shot."
            } else {
                let shown = min(count, project.length)
                return "You have made: \(shown)/\(project.length) stitches"
            }

        } else {
            if nextHole(predictions) == nil {
                return "No stitches detected. Try better lighting or a closer shot."
            } else {
                return "Your next hole is pointed out by the red arrow."
            }
        }
    }
    
    private func updateOverlay() {
        if selectedView == views[0] {
            overlayImage = drawPredictions(predictions, on: inputImage)
        } else if let hole = nextHole(predictions) {
            overlayImage = drawNextHoleArrow(hole, on: inputImage)
        } else {
            overlayImage = inputImage
        }
    }
    
    func nextHole(_ preds: [[String: Any]]) -> [String: Any]? {
        preds.min {
            (($0["x"] as? NSNumber)?.doubleValue ?? 0) < (($1["x"] as? NSNumber)?.doubleValue ?? 0)
        }
    }
}

#Preview {
    let project = ProjectData(name: "Sample", length: 24)
    project.rows = [Row(stitchType: "Single Crochet", progress: 0)]
    return ResultScreen(
        showCamera: .constant(true),
        inputImage: UIImage(named: "test_crochet_1") ?? UIImage(),
        project: project,
        rowIndex: 0
    )
}
