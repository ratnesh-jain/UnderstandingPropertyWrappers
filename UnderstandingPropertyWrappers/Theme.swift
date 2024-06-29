//
//  Theme.swift
//  UnderstandingPropertyWrappers
//
//  Created by Ratnesh Jain on 29/06/24.
//

import Foundation
import SwiftUI


enum Colors: CaseIterable, Codable {
    case blue
    case red
    case orange
    
    var color: Color {
        switch self {
        case .blue:
            return .blue
        case .red:
            return .red
        case .orange:
            return .orange
        }
    }
    
    var title: String {
        switch self {
        case .blue:
            return "Blue"
        case .red:
            return "Red"
        case .orange:
            return "Orange"
        }
    }
}

struct Theme: Codable {
    var tintColor: Colors = .blue
}
