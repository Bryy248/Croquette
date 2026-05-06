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
    @State var projectSave = false
    @State private var createdProject: ProjectData?
    @State private var validationError: String?
    @FocusState private var isLengthFieldFocused: Bool
    
    var body: some View {
//        NavigationStack {
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
                                    .onChange(of: name) { _, _ in
                                        if !name.isEmpty {
                                            validationError = nil
                                        }
                                    }
                            }
                            .font(.subheading)
                            HStack {
                                Text("Length")
                                Spacer()
                                TextField("", text: $chain)
                                    .multilineTextAlignment(.trailing)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 52, height: 25)
                                    .focused($isLengthFieldFocused)
                                    .onChange(of: chain) { _, _ in
                                        if !chain.isEmpty {
                                            validationError = nil
                                        }
                                    }
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
                        } footer: {
                            if let error = validationError {
                                Text(error)
                                    .font(.bodyText)
                                    .foregroundStyle(.red)
                                    .padding(.top, 4)
                            }
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
                        // Validasi
                        if name.isEmpty && chain.isEmpty {
                            validationError = "Please fill in both Name and Length."
                        }
                        else if name.isEmpty {
                            validationError = "Please fill in the Name."
                        }
                        else if name.count > 20 {
                            validationError = "Name must be 20 characters or less."
                        }
                        else if chain.isEmpty {
                            validationError = "Please fill in the Length."
                        }
                        else if Int(chain) == nil {
                            validationError = "Length must be a number."
                        }
                        else if let chainValue = Int(chain), chainValue == 0 {
                            validationError = "Length must be greater than 0."
                        }
                        else if let chainValue = Int(chain), chainValue > 100 {
                            validationError = "Length must be less than 100."
                        }
                        else {
                            validationError = nil
                            
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
                            projectSave = true
                        }
                        
                    }
                    .alert("Project Saved.", isPresented: $projectSave) {
                        Button("Go to Project Details", role: .cancel) {
                            navigateToDetail = true
                        }
                    }
                    
                }
                .navigationTitle(Text("New Project"))
                .navigationDestination(isPresented: $navigateToDetail) {
                    if let project = createdProject {
                        ProjectDetailView(project: project)
                    }
                }
            }
//        }
    }
}

#Preview {
    NewProjectView()
        .modelContainer(for: [ProjectData.self, Row.self], inMemory: true)
}
