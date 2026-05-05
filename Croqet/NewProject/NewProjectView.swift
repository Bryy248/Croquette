//
//  NewProjectView.swift
//  Croqet
//
//  Created by Brian Chang on 02/05/26.
//

import SwiftUI
import SwiftData

struct NewProjectView: View {
    
    @Environment(\.modelContext) var context // DATA
    @Environment(\.dismiss) var dismiss // DATA
    
    @State private var name: String = ""
    @State private var chain: String = ""
    @State private var rows: [RowDraft] = [RowDraft()]
    
    @State private var navigateToDetail = false
    @State private var createdProject: ProjectData?
    
    @State private var showingAlert = false
    var body: some View {
        NavigationStack {
            ZStack {
                Color("background_color")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    List {
                        Section {
                            HStack {
                                Text("Name")
                                TextField("New Project", text: $name)
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Text("Length")
                                Spacer()
                                TextField("", text: $chain)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 52, height: 25)
                                Text("chains")
                                    .foregroundStyle(.secondary)
                            }
                        } header: {
                            Text("Project Details")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(.black)
                                .padding(.bottom, 12)
                        }
                        
                        Section {
                            ForEach($rows) { $row in
                                RowCard(
                                    rowNumber: rows.firstIndex(where: { $0.id == row.id })! + 1,
                                    row: $row,
                                    onDelete: {
                                        rows.removeAll { $0.id == row.id }
                                    }
                                )
                            }
                        } header: {
                            HStack {
                                Text("Rows")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundStyle(.black)
                                
                                Spacer()
                                
                                HStack {
                                    Button(action: {
                                        rows.append(RowDraft())
                                    }) {
                                        Text("+ Add Row")
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
                    CroqetButton(title: "Save", colorScheme: "button_color") {
                        if name.isEmpty || chain.isEmpty {
                            showingAlert = true
                        }
                        else {
                            // data
                            let newProject = ProjectData(
                                name: name,
                                length: Int(chain) ?? 0
                            )
                            // convert dari draft ke model utama
                            newProject.rows = rows.map { draft in
                                Row(
                                    stitchType: draft.stitchType,
                                    progress: draft.progress
                                )
                            }
                            context.insert(newProject)
                            createdProject = newProject
                            navigateToDetail = true
                        }
                        
                    }
                    .alert("You haven't filled the project details.", isPresented: $showingAlert) {
                        Button("Fill Project Details", role: .cancel) { }
                    } message: {
                        Text("Fill them before continuing.")
                    }
                    
                }
                .navigationTitle(Text("New Project"))
                .navigationDestination(isPresented: $navigateToDetail) {
                    if let project = createdProject {
                        ProjectDetailView(project: project)
                    }
                }
            }
        }
    }
    
}

#Preview {
    NewProjectView()
        .modelContainer(for: [ProjectData.self, Row.self], inMemory: true)
}
