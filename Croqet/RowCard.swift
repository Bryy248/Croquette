//
//  RowCard.swift
//  Croqet
//
//  Created by Brian Chang on 30/04/26.
//

import SwiftUI
import AppMigrationKit

struct RowCard: View {
    @State private var selectedOption = "Single Crochet (SC0)"
    let options = ["Single Crochet (SC0)", "Double Crochet (DC0)", "Half Double Crochet (HDC0)"]
    var body: some View {
        HStack {
            Text("Row 1")
            
            Spacer()
            
            VStack {
                Picker("Apperance:", selection: $selectedOption) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                    }
                }
            }
        }
        .padding(16)
    }
}

#Preview {
    RowCard()
}
