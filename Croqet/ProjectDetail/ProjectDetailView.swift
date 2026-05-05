//
//  ProjectDetail.swift
//  Croqet
//
//  Created by Brian Chang on 02/05/26.
//

import SwiftUI
import SwiftData

struct ProjectDetailView: View {
    @Environment(\.modelContext) var context
    @State private var isEditing = false
    @State private var draftRows: [Row] = []
    let project: ProjectData
    @State var projectSave = false
    
    func startEditing() {
        draftRows = project.rows.map {
            Row(stitchType: $0.stitchType, progress: $0.progress)
        }
        isEditing = true
    }
    
    func cancelEditing() {
        draftRows = []
        isEditing = false
    }
    
    func saveEditing() {
        project.rows = draftRows
        isEditing = false
        projectSave = true
    }
    
    func deleteRow(_ row: Row) {
        if let index = project.rows.firstIndex(where: { $0 === row }) {
            project.rows.remove(at: index)
            context.delete(row)
        }
    }
    
    var body: some View {
        ZStack {
            Color("background_color")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                List {
                    Section {
                        HStack {
                            Text("Name")
                            Spacer()
                            Text(project.name)
                                .foregroundStyle(.secondary)
                        }
                        .font(.subheading)
                        HStack {
                            Text("Length")
                            Spacer()
                            Text("\(project.length)")
                                .foregroundStyle(.secondary)
                            Text("chains")
                                .foregroundStyle(.secondary)
                        }
                        .font(.subheading)
                    } header: {
                        Text("Project Details")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.black)
                            .padding(.bottom, 12)
                    }
                    
                    Section {
                        let rowsToUse = isEditing ? draftRows : project.rows

                        ForEach(Array(rowsToUse.enumerated()), id: \.offset) { index, row in
                            RowProgressCard(
                                rowNumber: index + 1,
                                length: project.length,
                                row: row,
                                isEditable: isEditing,
                                onDelete: isEditing ? {
                                    draftRows.remove(at: index)
                                } : nil
                            )
                        }
                    } header: {
                        HStack {
                            Text("Rows")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            HStack {
                                if isEditing {
                                    Button(action: {
                                        draftRows.append(Row())
                                    }) {
                                        Text("+ Add Row")
                                    }
                                }
                            }
                            .tint(.gray)
                        }
                        .padding(.bottom, 12)
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                
                Spacer()
                if isEditing {
                    CroqetButton(title: "Save", colorScheme: "button_color") {
                        saveEditing()
                        
                    }
                    .alert("Project Saved.", isPresented: $projectSave) {
                        Button("Back to Project Details", role: .cancel) {
                        }
                    }
                    
                }
                else {
                    CroqetButton(title: "Get Assistance", colorScheme: "button_color") {
                        // ke page camera
                    }
                }
            }
            .navigationTitle(Text(project.name))
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !isEditing {
                    Button("Edit") {
                        startEditing()
                    }
                }
            }
        }
    }
}

#Preview {
    ProjectDetailView( project: ProjectData(name: "Taplak", length: 20))
        .modelContainer(for: [ProjectData.self, Row.self], inMemory: true)
}
