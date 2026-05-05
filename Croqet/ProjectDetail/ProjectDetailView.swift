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
    @Environment(\.dismiss) var dismiss
    @State private var isEditing = false
    @State private var draftRows: [Row] = []
    @State private var newlyAddedRowIndices: Set<Int> = []
    let project: ProjectData
    @State var projectSave = false
    @State private var showCamera = false
    @State private var showDiscardAlert = false
    
    func startEditing() {
        draftRows = project.rows.map {
            Row(stitchType: $0.stitchType, progress: $0.progress)
        }
        isEditing = true
        newlyAddedRowIndices.removeAll()
    }
    
    func cancelEditing() {
        draftRows = []
        isEditing = false
        newlyAddedRowIndices.removeAll()
    }
    
    func saveEditing() {
        project.rows = draftRows
        isEditing = false
        projectSave = true
        newlyAddedRowIndices.removeAll()
    }
    
    func deleteRow(_ row: Row) {
        if let index = project.rows.firstIndex(where: { $0 === row }) {
            project.rows.remove(at: index)
            context.delete(row)
        }
    }
    
    // bikin handler soalnya ada issue swiftui type-checker overload
    private func deleteHandler(for index: Int, isCompleted: Bool) -> (() -> Void)? {
        guard isEditing && !isCompleted else { return nil }
        return {
            if let indexToRemove = newlyAddedRowIndices.first(where: { $0 == index }) {
                newlyAddedRowIndices.remove(indexToRemove)
            }
            newlyAddedRowIndices = Set(newlyAddedRowIndices.map { $0 > index ? $0 - 1 : $0
            })
            draftRows.remove(at: index)
        }
    }
    
    @ViewBuilder
    private func rowCard(index: Int, row: Row, rowsToUse: [Row]) -> some View {
        let isNewlyAdded = newlyAddedRowIndices.contains(index)
        let isLocked = !isNewlyAdded && index > 0 && (rowsToUse[index - 1].progress <
                                                      project.length)
        let isCompleted = row.progress == project.length
        
        RowProgressCard(
            rowNumber: index + 1,
            length: project.length,
            row: row,
            isEditable: isEditing,
            onDelete: deleteHandler(for: index, isCompleted: isCompleted),
            isLocked: isLocked,
            isCompleted: isCompleted
        )
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
                            .font(.heading)
                            .foregroundStyle(.black)
                            .padding(.bottom, 12)
                            .padding(.leading, -15)

                    }
                    
                    Section {
                        let rowsToUse = isEditing ? draftRows : project.rows
                        
                        ForEach(Array(rowsToUse.enumerated()), id: \.offset) { index, row in
                            rowCard(index: index, row: row, rowsToUse: rowsToUse)
                                .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                        }
                        
                    } header: {
                        HStack {
                            Text("Rows")
                                .font(.heading)
                                .foregroundStyle(.black)
                                .padding(.bottom, -5)
                                .padding(.leading, -15)
                            
                            Spacer()
                            
                            HStack {
                                if isEditing {
                                    Button(action: {
                                        draftRows.append(Row())
                                        newlyAddedRowIndices.insert(draftRows.count - 1)
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
                    
                } else {
                    CroqetButton(title: "Get Assistance", colorScheme: "button_color") {
                        showCamera = true
                    }
                    .fullScreenCover(isPresented: $showCamera) {
                        let activeRowIndex = project.rows.firstIndex(where: { $0.progress < project.length }) ??
                        0
                        CameraView(showCamera: $showCamera, project: project, rowIndex: activeRowIndex)
                    }
                }
            }
            .navigationTitle(Text(project.name))
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if isEditing {
                        showDiscardAlert = true
                    }
                    else {
                        dismiss()
                    }
                })
                {
                    Image(systemName: "chevron.left")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if !isEditing {
                    Button("Edit") {
                        startEditing()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("Unsaved Changes", isPresented: $showDiscardAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Discard", role: .destructive) {
                cancelEditing()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to continue?")
        }
    }
}

#Preview {
    ProjectDetailView(project: ProjectData(name: "Taplak", length: 20))
        .modelContainer(for: [ProjectData.self, Row.self], inMemory: true)
}
