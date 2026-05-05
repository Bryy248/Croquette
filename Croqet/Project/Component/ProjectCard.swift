//
//  HistoryCard.swift
//  Croqet
//
//  Created by Brian Chang on 30/04/26.
//

import SwiftUI
import SwiftData

struct ProjectCard: View {
    let projects: ProjectData
    var onDelete: (() -> Void)?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 10) {
            // String
            Text(projects.name)
                .font(.system(size:20, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Date Format
            Text(projects.lastModified, formatter: dateFormatter)
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
    ProjectCard(projects: (ProjectData(name: "Pouch", length: 10)))
        .modelContainer(for: [ProjectData.self, Row.self], inMemory: true)
}
