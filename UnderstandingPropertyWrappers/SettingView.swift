//
//  SettingView.swift
//  UnderstandingPropertyWrappers
//
//  Created by Ratnesh Jain on 29/06/24.
//

import Foundation
import SwiftUI

struct SettingView: View {
    @Shared(.appStorage("count")) var count: Int = 0
    @Shared(.appStorage("theme")) var theme: Theme = .init()
    
    var body: some View {
        List {
            Text("Count: \(count)")
            Picker("Theme", selection: $theme.tintColor) {
                ForEach(Colors.allCases, id: \.self) { color in
                    Text(color.title)
                }
            }
        }
    }
}
