//
//  RowCard.swift
//  Croqet
//
//  Created by Brian Chang on 30/04/26.
//

import SwiftUI

struct RowCard: View {
    let rowNumber: Int
    @State private var selectedOption = "Single Crochet (SC0)"
    let options = ["Single Crochet (SC0)", "Double Crochet (DC0)", "Half Double Crochet (HDC0)"]
    
    var body: some View {
        HStack {
            Text("Row \(rowNumber)")
            
            Spacer()
            
            Picker("Apperance:", selection: $selectedOption) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
            
            Text("Stitches")
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
