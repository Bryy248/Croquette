//
//  ContentView.swift
//  Croquette
//
//  Created by Brian Chang on 27/04/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var projects: [ProjectData] // DATA
    @Environment(\.modelContext) var context // DATA
    
    // Delete function
    private func deleteProject(_ project: ProjectData) {
        withAnimation {
            context.delete(project)
        }
    }
    
    @State private var newProjectNavigate: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Color
                Color("background_color")
                    .ignoresSafeArea()
                
                // Main Content
                VStack(spacing: 0) {
                    // Header
                    Text("Projects")
                        .font(.title)
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
                            ForEach(projects) { project in
                                NavigationLink(destination: ProjectDetailView(project: project)) {
                                    HStack(){
                                        ProjectCard(projects: project) {
                                            deleteProject(project)
                                        }
                                        
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.subheading)
                                            .foregroundStyle(.button)
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
                    CroqetButton(title: "Add Project", colorScheme: "button_color") {
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
        .modelContainer(for: [ProjectData.self, Row.self], inMemory: true)
}
