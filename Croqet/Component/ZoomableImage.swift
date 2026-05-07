//
//  ZoomableImage.swift
//  Croqet
//
//  Created by Sayyidah Fatimah Azzahra on 07/05/26.
//

import SwiftUI

struct ZoomableImage: View {
    let image: UIImage
    var maxScale: CGFloat = 5.0
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geo in
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .scaleEffect(scale)
                .offset(offset)
                .clipped()
                .contentShape(Rectangle())
                .gesture(
                    SimultaneousGesture(magnification(in: geo.size), drag(in:
                                                                            geo.size))
                )
                .onTapGesture(count: 2, perform: toggleZoom)
        }
    }
    
    private func magnification(in size: CGSize) -> some Gesture {
        MagnificationGesture()
            .onChanged {
                scale = max(1.0, min(lastScale * $0, maxScale))
                offset = clamp(offset, scale: scale, in: size)
            }
            .onEnded { _ in
                lastScale = scale
                withAnimation(.spring()) {
                    offset = clamp(offset, scale: scale, in: size)
                    lastOffset = offset
                }
            }
    }
    
    private func drag(in size: CGSize) -> some Gesture {
        DragGesture()
            .onChanged {
                let proposed = CGSize(
                    width: lastOffset.width + $0.translation.width,
                    height: lastOffset.height + $0.translation.height
                )
                offset = clamp(proposed, scale: scale, in: size)
            }
            .onEnded { _ in lastOffset = offset }
    }
    
    private func clamp(_ offset: CGSize, scale: CGFloat, in size: CGSize) -> CGSize {
        let maxX = max(0, (size.width  * (scale - 1)) / 2)
        let maxY = max(0, (size.height * (scale - 1)) / 2)
        return CGSize(
            width:  min(maxX, max(-maxX, offset.width)),
            height: min(maxY, max(-maxY, offset.height))
        )
    }
    
    private func toggleZoom() {
        withAnimation(.spring()) {
            scale = scale > 1.0 ? 1.0 : 2.5
            lastScale = scale
            offset = .zero
            lastOffset = .zero
        }
    }
    
    private func resetOffset() {
        withAnimation(.spring()) { offset = .zero; lastOffset = .zero }
    }
}
