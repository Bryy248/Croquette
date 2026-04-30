//
//  HistoryCard.swift
//  Croqet
//
//  Created by Brian Chang on 30/04/26.
//

import SwiftUI

struct HistoryCard: View {
    var body: some View {
        HStack() {
            Rectangle()
                .cornerRadius(20)
                .frame(width: 72, height: 72)
                .overlay(
                    Image(systemName: "person.crop.circle")
                )
                .padding(.trailing, 16)
            
            
            VStack(alignment: .leading) {
                // String
                Text("Taplak")
                    .font(.system(size:30))
                    .foregroundColor(.secondary)
                
                // Date Format
                Text("10/10/2020")
                    .font(.system(size:10))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
    }
}

#Preview {
    HistoryCard()
}
