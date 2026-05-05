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
    
    @State private var showCamera = false // CAMERA
    
    @State private var name: String = ""
    @State private var totalRow: Int = 5
    @State private var chain: String = ""
    
    @State private var showingAlert = false
    var body: some View {
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
                        ForEach(1...totalRow, id: \.self) { row in
                            RowCard(rowNumber: row)
                        }
                    } header: {
                        HStack {
                            Text("Rows")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            HStack {
                                Button(action: {
                                    totalRow += 1
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
                .background(Color.gray.opacity(0.1)) // atau gunakan Color(uiColor: .systemGray6) untuk warna gray sistem
                
                Spacer()
                CroqetButton(title: "Save", colorScheme: "button_color") {
                    if name.isEmpty || chain.isEmpty {
                        showingAlert = true
                    } else {
                        // data
                        let newProject = ProjectData(
                            name: name,
                            length: Int(chain) ?? 0
                        )
                        for _ in 1...totalRow {
                            let row = Row()
                            newProject.rows.append(row)
                        }
                        context.insert(newProject)
                        dismiss()
                    }
                    
                }
                .alert("You haven't filled the project details.", isPresented: $showingAlert) {
                    Button("Fill Project Details", role: .cancel) { }
                } message: {
                    Text("Fill them before continuing.")
                }
                
            }
            .navigationTitle(Text("New Project"))
        }
    }
    
}

#Preview {
    NewProjectView()
        .modelContainer(for: [ProjectData.self, Row.self], inMemory: true)
}
