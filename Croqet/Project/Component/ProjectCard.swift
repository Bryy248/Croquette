//
//  HistoryCard.swift
//  Croqet
//
//  Created by Brian Chang on 30/04/26.
//

import SwiftUI

struct ProjectCard: View {
    let projects: TemporaryProject
    var onDelete: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 10) {
            // String
            Text(projects.name)
                .font(.system(size:20, weight: .semibold))
                .foregroundColor(.black)
            
            // Date Format
            Text("10/10/2020")
                .font(.system(size:12))
                .foregroundColor(.gray)
        }
        .swipeActions{
            Button(role: .destructive) {
                onDelete?()
            } label: {
                Label("", systemImage: "trash")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(20)
    }
}

#Preview {
    ProjectCard(projects: (TemporaryProject(name: "Pouch")))
}
