//
//  Fonts.swift
//  Croqet
//
//  Created by Brian Chang on 05/05/26.
//
import SwiftUI
import UIKit

extension Font {
    static let title = Font.system(size: 36, weight: .semibold)
    static let heading = Font.system(size: 24, weight: .semibold)
    static let subheading = Font.system(size: 17, weight: .medium)
    static let bodyText = Font.system(size: 12, weight: .regular)
}

extension UIFont {
    static let title = UIFont.systemFont(ofSize: 36, weight: .semibold)
    static let heading = UIFont.systemFont(ofSize: 24, weight: .semibold)
    static let subheading = UIFont.systemFont(ofSize: 13, weight: .medium)
    static let bodyText = UIFont.systemFont(ofSize: 12, weight: .regular)
}

// Cara menggunakan
//Text("Title")
//    .font(.heading)
