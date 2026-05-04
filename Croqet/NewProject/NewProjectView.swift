//
//  NewProjectView.swift
//  Croqet
//
//  Created by Brian Chang on 02/05/26.
//

import SwiftUI

struct NewProjectView: View {
    @State private var name: String = ""
    @State private var totalRow: Int = 5
    @State private var chain: String = ""
    var body: some View {
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
            CroqetButton(title: "Get Assistance", colorScheme: "color5") {
                
            }

        }
        .navigationTitle(Text("New Project"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    
                    
                }
            }
        }
    }
}

#Preview {
    NewProjectView()
}
