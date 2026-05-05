//
//  ProjectData.swift
//  Croqet
//
//  Created by Agnetta Indira Revata on 05/05/26.
//

import SwiftData
import Foundation

// Model sementara untuk user apabila tidak jadi menyimpan project
struct RowDraft: Identifiable {
    let id = UUID()
    var stitchType: String = "Single Crochet"
    var progress: Int = 0
}

@Model
class ProjectData {
    var name: String
    var length: Int
    var lastModified: Date
    var rows: [Row]
    
    init(name: String, length: Int) { // lastmodified and rows arent here cuz they always start empty
        self.name = name
        self.length = length
        self.lastModified = Date() // set to now. !!!always update this when edited
        self.rows = []
    }
}

@Model
class Row {
    var stitchType: String
    var progress: Int
    // var project: ProjectData?
    
    init(stitchType: String = "Single Crochet", progress: Int = 0) {
        self.stitchType = stitchType
        self.progress = progress
    }
}
