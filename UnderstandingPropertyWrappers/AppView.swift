//
//  AppView.swift
//  UnderstandingPropertyWrappers
//
//  Created by Ratnesh Jain on 29/06/24.
//

import Foundation
import SwiftUI

struct AppView: View {
    @Shared(.appStorage("theme")) var theme: Theme = .init()
    
    var body: some View {
        TabView {
            ContentView()
                .tabItem { Label("Content", systemImage: "house") }
            SettingView()
                .tabItem { Label("Settings", systemImage: "gear") }
        }
        .tint(theme.tintColor.color)
    }
}

#Preview {
    AppView()
}
