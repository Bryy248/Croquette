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
    // segmented control perlu UIFonts dari UIKit dan perlu diinitialize waktu init
    init() {
        UISegmentedControl.appearance().setTitleTextAttributes([.font:
                                                                    UIFont.subheading], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.font:
                                                                    UIFont.subheading], for: .selected)
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
        .modelContainer(for: [ProjectData.self, Row.self])
    }
}
