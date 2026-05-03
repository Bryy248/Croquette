//
//  Button.swift
//  Croqet
//
//  Created by Brian Chang on 30/04/26.
//

import SwiftUI

struct CroqetButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 125,height: 48)
                .background(.blue)
                .cornerRadius(12)
        }
    }
}

#Preview {
    CroqetButton(title: "Save", action: {
        print("Button tapped!")
    })
    .padding()
}
