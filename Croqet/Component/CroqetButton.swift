//
//  Button.swift
//  Croqet
//
//  Created by Brian Chang on 30/04/26.
//

import SwiftUI

struct CroqetButton: View {
    let title: String
    let colorScheme: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.font)
                .frame(width: 361,height: 48)
                .background(Color(colorScheme))
                .cornerRadius(12)
        }
    }
}

#Preview {
    CroqetButton(title: "Save", colorScheme: "color3", action: {
        print("Button tapped!")
    })
    .padding()
}
