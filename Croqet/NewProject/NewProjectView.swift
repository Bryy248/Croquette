//
//  NewProjectView.swift
//  Croqet
//
//  Created by Brian Chang on 02/05/26.
//

import SwiftUI

struct NewProjectView: View {
    @State private var name: String = ""
    @State private var totalRow: Int = 1
    var body: some View {
        VStack(spacing: 0) {
            // Scrollable Content
            ScrollView {
                VStack(spacing: 8) {
                    
                    VStack(){
                        Rectangle()
                            .frame(width: 250, height: 200)
                        
                        Text("Add Project Cover")
                    }
                    .padding(.vertical, 4)
                    
                    VStack(alignment: .leading) {
                        Text("Project Name")
                            .font(Font.body.bold())
                        TextField("Enter your name", text: $name)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 20){
                        Text("Add Project Detail")
                            .font(Font.body.bold())
                        
                        HStack(alignment: .center, spacing: 12) {
                            Text("Length")
                                .font(.system(size: 14, weight: .medium))
                            
                            Spacer()
                            
                            TextField("Add Chain", text: .constant(""))
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 50)
                            
                            Text("chains")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(BackgroundBorder())
                        .frame(maxWidth: .infinity)
                        
                        List {
                            ForEach(1...totalRow, id: \.self) { row in
                                RowCard(rowNumber: row)
                            }
                            .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0)) // Spacing antar item
                            .listRowSeparator(.hidden) // Hilangkan separator
                            .listRowBackground(Color.clear) // Background transparan
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden) // Hilangkan background default List
                        .frame(height: CGFloat(totalRow) * 52)
                        
                        Button {
                            totalRow += 1
                        } label: {
                            Text("+ Add Row")
                        }
                    }
                    .padding(.bottom, 16)
                }
                .padding(16)
            }
            CroqetButton(title: "Save Project") {
                
            }
        }
        .navigationTitle(Text("New Project"))
    }
}

#Preview {
    NewProjectView()
}
