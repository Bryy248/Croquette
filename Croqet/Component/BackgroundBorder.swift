//
//  Background.swift
//  Croqet
//
//  Created by Brian Chang on 03/05/26.
//

import SwiftUI

struct BackgroundBorder: View {
    var showShadow: Bool = true
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white)
            .shadow(
                color: showShadow ? .black.opacity(0.1) : .clear,
                radius: showShadow ? 8 : 0,
                x: 0,
                y: showShadow ? 4 : 0
            )
    }
}
