//
//  ContentView.swift
//  Croquette
//
//  Created by Brian Chang on 27/04/26.
//

import SwiftUI

// Temporary Model
struct TemporaryProject: Identifiable {
    let id = UUID()
    var name: String
}

struct ContentView: View {
    // Temporary
    @State private var projects: [TemporaryProject] =  [TemporaryProject(name: "tapak")]
      //[]
    
    // Delete function
    private func deleteProject(_ project: TemporaryProject) {
        withAnimation {
            projects.removeAll { $0.id == project.id }
        }
    }
    
    @State private var newProjectNavigate: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack() {
                // Background Color Layer
                Color("color2")
                    .ignoresSafeArea()
                
                // Second Layer
                VStack (spacing: 16) {
                    HStack () {
                        Image(systemName: "star")
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                        Text("Hi Mia!")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        if projects.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Projects")
                                    .bold()
                                    .font(.system(size: 36))
                                
                                Text("No existing project.")
                                    .fontWeight(.semibold)
                                    .font(Font.system(size: 16))
                                    .foregroundStyle(.gray)
                            }
                        }
                        else {
                            HStack {
                                Text("Projects")
                                    .bold()
                                    .font(.system(size: 36))
                                Spacer()
                                Button {
                                    newProjectNavigate = true
                                } label: {
                                    Image(systemName: "plus")
                                        .foregroundStyle(.blue)
                                }
                                .buttonStyle(.glass)
                                .tint(.blue)
                                .controlSize(ControlSize.large)
                                .buttonBorderShape(.circle)

                            }
                            List {
                                ForEach($projects) { $project in
                                    NavigationLink(destination: ProjectDetailView(project: project)) {
                                        ProjectCard(projects: project) {
                                            deleteProject(project)
                                        }
                                    }
                                    .navigationLinkIndicatorVisibility(.hidden) // Menghilangkan cevron di list
                                    .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0)) // Spacing antar item
                                    .listRowSeparator(.hidden) // Hilangkan separator
                                    .listRowBackground(Color.clear) // Background transparan
                                }
                            }
                            .listStyle(.plain)
                            .scrollContentBackground(.hidden) // Hilangkan background default List
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    if projects.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "star")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            
                            Text("What are you making?")
                                .fontWeight(.semibold)
                                .font(Font.system(size: 24))
                                .foregroundStyle(.primary)
                            
                            CroqetButton(title: "Add Project") {
                                newProjectNavigate = true
                            }
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(16)
            }
            .frame(maxWidth: .infinity , maxHeight: .infinity)
            .navigationDestination(isPresented: $newProjectNavigate) {
                NewProjectView()
            }
        }
    }
}

#Preview {
    ContentView()
}
