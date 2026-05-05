//
//  ProjectData.swift
//  Croqet
//
//  Created by Agnetta Indira Revata on 05/05/26.
//

import SwiftData
import Foundation

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
    var progress: Int
    // var project: ProjectData?
    
    init(progress: Int = 0) {
        self.progress = progress
    }
}
