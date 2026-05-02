//
//  ProjectDetail.swift
//  Croqet
//
//  Created by Brian Chang on 02/05/26.
//

import SwiftUI

struct ProjectDetailView: View {
    let project: TemporaryProject
    var body: some View {
        Text(project.name)
    }
}

#Preview {
    ProjectDetailView(project: TemporaryProject(name: "tapak"))
}
