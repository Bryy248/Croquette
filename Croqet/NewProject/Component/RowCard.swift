//
//  RowCard.swift
//  Croqet
//
//  Created by Brian Chang on 30/04/26.
//

import SwiftUI

struct RowCard: View {
    let rowNumber: Int
    @State private var selectedOption = "Single Crochet"
    let options = ["Single Crochet", "Double Crochet", "Half Double Crochet"]
    var onDelete: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Text("Row \(rowNumber)")
                .font(.system(size: 14, weight: .medium))
            
            Spacer()
            
            Picker("", selection: $selectedOption) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
            .font(.system(size: 14))
            .tint(.gray)
            
            Text("Stitches")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(BackgroundBorder(showShadow: false))
        .frame(maxWidth: .infinity)
        .swipeActions{
            Button(role: .destructive) {
                onDelete?()
            } label: {
                Label("", systemImage: "trash")
            }
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        ForEach(1...5, id: \.self) { row in
            RowCard(rowNumber: row)
        }
    }
}
