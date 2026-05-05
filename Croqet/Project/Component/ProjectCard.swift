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
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Date Format
            Text("10/10/2020")
                .font(.system(size:12))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .swipeActions{
            Button(role: .destructive) {
                onDelete?()
            } label: {
                Label("", systemImage: "trash")
            }
        }
        .padding(20)
    }
}

#Preview {
    ProjectCard(projects: (TemporaryProject(name: "Pouh")))
}
