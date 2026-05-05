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
    var isLocked: Bool = false  // Row belum bisa diakses
    var isCompleted: Bool = false  // Row sudah 100%
    
    var progressValue: Double {
        guard length > 0 else { return 0 }
        guard row.progress >= 0, row.progress <= length else { return 0 }
        
        return Double(row.progress) / Double(length)
    }
    
    var body: some View {
        ZStack {
            VStack() {
                HStack {
                    HStack(spacing: 6) {
                        Text("Row \(rowNumber)")
                        
                        // Lock icon untuk row yang sudah complete
                        if isCompleted {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Picker("", selection: $row.stitchType) {
                        ForEach(options, id: \.self) { option in
                            Text(option).font(.subheading)
                        }
                    }
                    .font(.subheading)
                    .disabled(!isEditable || isLocked || isCompleted)
                    .tint(.black)
                    .opacity(isLocked ? 0.3 : 1.0)
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
            .opacity(isLocked ? 0.3 : 1.0)
            .blur(radius: isLocked ? 2 : 0)
            
            // Lock overlay untuk row yang belum bisa diakses
            if isLocked {
                VStack(spacing: 8) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.gray)
                    
                    Text("Row \(rowNumber)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.gray)
                }
            }
        }
        .swipeActions {
            if isEditable && !isLocked && !isCompleted {
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
    List {
        // Active row
        RowProgressCard(
            rowNumber: 1,
            length: 24,
            row: Row(progress: 12),
            isEditable: true,
            isLocked: false,
            isCompleted: false
        )
        
        // Locked row (belum bisa diakses)
        RowProgressCard(
            rowNumber: 2,
            length: 24,
            row: Row(),
            isEditable: true,
            isLocked: true,
            isCompleted: false
        )
        
        // Completed row
        RowProgressCard(
            rowNumber: 3,
            length: 24,
            row: Row(progress: 24),
            isEditable: true,
            isLocked: false,
            isCompleted: true
        )
    }
}
