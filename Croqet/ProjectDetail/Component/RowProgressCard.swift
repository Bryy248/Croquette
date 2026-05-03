//
//  RowProgressCard.swift
//  Croqet
//
//  Created by Brian Chang on 30/04/26.
//

import SwiftUI

struct RowProgressCard: View {
    let rowNumber: Int
    let stitchRow: String
    var body: some View {
        VStack() {
            HStack {
                Text("Row \(rowNumber)")
                Spacer()
                Text("\(stitchRow) Stitches")
            }
            .padding(.bottom, 10)
            
            ProgressView(value: 0.75)
                .scaleEffect(y: 4, anchor: .center)
                .frame(height: 21)
            
            Text("0/0 stitches done")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
    }
}

#Preview {
    RowProgressCard(rowNumber: 1, stitchRow: "Single Crochet")
}
