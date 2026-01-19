//
//  KeyboardView.swift
//  mous
//
//  Created by Prashant Revaneti on 1/10/26.
//

import SwiftUI

struct KeyboardView: View {
    @State private var inputText = ""

    var body: some View {
        VStack(spacing: 16) {
            // Text input section
            TextField("Type text here...", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                guard !inputText.isEmpty else { return }
                NetworkManager.shared.sendText(inputText)
                inputText = ""
            }) {
                Text("Send Text")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(inputText.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(inputText.isEmpty)
            .padding(.horizontal)

            Divider()
                .padding(.vertical, 8)

            // Special keys section
            Text("Special Keys")
                .font(.headline)
                .foregroundColor(.gray)

            // Row 1: Escape, Tab, Backspace
            HStack(spacing: 12) {
                KeyButton(label: "Esc", key: "escape")
                KeyButton(label: "Tab", key: "tab")
                KeyButton(label: "Delete", key: "backspace", icon: "delete.left")
            }
            .padding(.horizontal)

            // Row 2: Enter (full width)
            KeyButton(label: "Return", key: "enter", icon: "return")
                .padding(.horizontal)

            // Row 3: Arrow keys
            VStack(spacing: 8) {
                KeyButton(label: "", key: "up", icon: "chevron.up")
                    .frame(width: 60)
                HStack(spacing: 12) {
                    KeyButton(label: "", key: "left", icon: "chevron.left")
                        .frame(width: 60)
                    KeyButton(label: "", key: "down", icon: "chevron.down")
                        .frame(width: 60)
                    KeyButton(label: "", key: "right", icon: "chevron.right")
                        .frame(width: 60)
                }
            }
            .padding(.top, 8)

            // Row 4: Common shortcuts
            HStack(spacing: 12) {
                KeyButton(label: "Space", key: "space")
                KeyButton(label: "Home", key: "home")
                KeyButton(label: "End", key: "end")
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
    }
}

struct KeyButton: View {
    let label: String
    let key: String
    var icon: String? = nil

    var body: some View {
        Button(action: {
            NetworkManager.shared.sendKey(key)
        }) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                }
                if !label.isEmpty {
                    Text(label)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.gray.opacity(0.3))
            .foregroundColor(.primary)
            .cornerRadius(8)
        }
    }
}

#Preview {
    KeyboardView()
}
