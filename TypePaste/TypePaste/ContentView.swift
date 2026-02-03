//
//  ContentView.swift
//  TypePaste
//
//  Created by Tim Haselaars on 03/02/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("TypePaste")
                .font(.title2)
            Text("Press Command + 1 to type the current clipboard text into the active app.")
                .fixedSize(horizontal: false, vertical: true)
            Text("If typing does not work, grant Accessibility permissions in System Settings > Privacy & Security > Accessibility.")
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(width: 420)
    }
}

#Preview {
    ContentView()
}
