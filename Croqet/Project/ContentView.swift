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
    @State private var projects: [TemporaryProject] = [TemporaryProject(name: "Pouch"), TemporaryProject(name: "Coaster"), TemporaryProject(name: "Cake")]
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
            ZStack {
                // Background Color
                Color("color2")
                    .ignoresSafeArea()
                
                // Main Content
                VStack(spacing: 0) {
                    // Header
                    Text("Projects")
                        .font(.system(size: 36, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.black)
                        .padding(.bottom, 24)
                    
                    // Content Area
                    if projects.isEmpty {
                        // Empty State
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "star")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(.secondary)
                            
                            Text("You have no projects yet")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(.primary)
                        }
                        Spacer()
                    } else {
                        // Projects List
                        List {
                            ForEach($projects) { $project in
                                NavigationLink(destination: ProjectDetailView(project: project)) {
                                    HStack(){
                                        ProjectCard(projects: project) {
                                            deleteProject(project)
                                        }
                                        
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundStyle(.color5)
                                            .padding(.trailing, 16)
                                    }
                                    
                                }
                                .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0)) //spacing antar item
                                .listRowSeparator(.hidden) //Menghilangkan separator
                                .listRowBackground(Color.clear) //Background Transparan
                                .background(BackgroundBorder())
                                .navigationLinkIndicatorVisibility(.hidden)
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                    
                    // Button at Bottom
                    CroqetButton(title: "Add Project", colorScheme: "color5") {
                        newProjectNavigate = true
                    }
                    .padding(.top, 16)
                }
                .padding(16)
            }
            .navigationDestination(isPresented: $newProjectNavigate) {
                NewProjectView()
                
            }
        }
    }
}

#Preview {
    ContentView()
}
