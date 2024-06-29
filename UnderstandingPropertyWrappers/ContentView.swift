//
//  ContentView.swift
//  UnderstandingPropertyWrappers
//
//  Created by Ratnesh Jain on 29/06/24.
//

import Combine
import SwiftUI

struct ContentView: View {
    @Shared(.appStorage("count")) private var count: Int = 0
    
    var body: some View {
        CounterView(count: $count)
    }
}

struct CounterView: View {
    @Binding var count: Int
    var body: some View {
        HStack {
            Button {
                count += 1
            } label: {
                Image(systemName: "plus")
                    .frame(height: 24)
            }
            Text("Count: \(count)")
            Button {
                count -= 1
            } label: {
                Image(systemName: "minus")
                    .frame(height: 24)
            }
        }
        .buttonStyle(.borderedProminent)
        .padding()
        .background(Material.regular, in: .rect(cornerRadius: 8))
    }
}

#Preview {
    ContentView()
}
