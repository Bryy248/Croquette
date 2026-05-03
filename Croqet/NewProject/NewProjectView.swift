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
        VStack(spacing: 8){
            
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
            
            VStack(alignment: .leading){
                Text("Add Project Detail")
                    .font(Font.body.bold())
                
                HStack {
                    Text("Length")
                    
                    Spacer()
                    
                    TextField("Add Chain", text: .constant(""))
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 50)
                    Text("chains")
                }
                VStack(spacing: 8) {
                    ForEach(1...totalRow, id: \.self) { row in
                        RowCard(rowNumber: row)
                    }
                }
                
                Button {
                    totalRow += 1
                } label: {
                    Text("+ Add Row")
                }
            }
            .padding(.bottom, 16)
            
            CroqetButton(title: "Save Project") {
                
            }
            
            Spacer()
            
        }
        .padding(16)
            .navigationTitle(Text("New Project"))
    }
}

#Preview {
    NewProjectView()
}
