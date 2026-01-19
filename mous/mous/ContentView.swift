//
//  ContentView.swift
//  mous
//
//  Created by Prashant Revaneti on 1/10/26.
//

import SwiftUI

struct ContentView: View {
    @State private var isDarkMode = true

    var body: some View {
        NavigationStack {
            TabView {
                TrackpadView()
                    .tabItem {
                        Image(systemName: "rectangle.and.hand.point.up.left.filled")
                        Text("Trackpad")
                    }

                KeyboardView()
                    .tabItem {
                        Image(systemName: "keyboard")
                        Text("Keyboard")
                    }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isDarkMode.toggle()
                    }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                    }
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
