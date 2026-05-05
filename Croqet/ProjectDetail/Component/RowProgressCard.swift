//
//  RowProgressCard.swift
//  Croqet
//
//  Created by Brian Chang on 30/04/26.
//

import SwiftUI

struct RowProgressCard: View {
    let rowNumber: Int
    let length: Int
    @Bindable var row: Row
    let options = ["Single Crochet", "Double Crochet", "Half Double Crochet"]
    var isEditable: Bool
    var onDelete: (() -> Void)?
    
    var progressValue: Double {
        guard length > 0 else { return 0 }
        guard row.progress >= 0, row.progress <= length else { return 0 }
        
        return Double(row.progress) / Double(length)
    }
    
    var body: some View {
        VStack() {
            HStack {
                Text("Row \(rowNumber)")
                Spacer()
                
                Picker("", selection: $row.stitchType) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                    }
                }
                .disabled(!isEditable)
                .tint(.black)
            }
            .font(.subheading)
            .padding(.bottom, 10)
            
            ProgressView(value: progressValue)
                .scaleEffect(y: 2, anchor: .center)
                .frame(height: 6)
                .tint(.button)
                .padding(.bottom, 12)
            
            Text("\(row.progress)/\(length) stitches")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .swipeActions {
            if isEditable {
                Button(role: .destructive) {
                    onDelete?()
                } label: {
                    Label("", systemImage: "trash")
                }
            }
        }
        .padding(16)
    }
}

#Preview {
    ForEach(1...5, id: \.self) { index in
        RowProgressCard(
            rowNumber: index,
            length: 24,
            row: Row(),
            isEditable: true
        )
    }
}
