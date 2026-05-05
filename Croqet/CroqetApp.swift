//
//  CroquetteApp.swift
//  Croquette
//
//  Created by Brian Chang on 27/04/26.
//

import SwiftUI
import SwiftData

@main
struct CroqetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [ProjectData.self, Row.self])
    }
}
