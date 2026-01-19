//
//  TrackpadView.swift
//  mous
//
//  Created by Prashant Revaneti on 1/10/26.
//

import SwiftUI

struct TrackpadView: View {
    @State private var lastPosition: CGPoint?

    var body: some View {
        VStack(spacing: 20) {
            // Trackpad area
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if let last = lastPosition {
                                let dx = value.location.x - last.x
                                let dy = value.location.y - last.y
                                NetworkManager.shared.sendMove(x: dx, y: dy)
                            }
                            lastPosition = value.location
                        }
                        .onEnded { _ in
                            lastPosition = nil
                        }
                )
                .simultaneousGesture(
                    TapGesture(count: 1)
                        .onEnded {
                            NetworkManager.shared.sendClick(button: "left")
                        }
                )
                .simultaneousGesture(
                    TapGesture(count: 2)
                        .onEnded {
                            NetworkManager.shared.sendClick(button: "right")
                        }
                )
                .overlay(
                    Text("Trackpad Area")
                        .foregroundColor(.gray.opacity(0.6))
                )

            // Click buttons
            HStack(spacing: 40) {
                Button(action: {
                    NetworkManager.shared.sendClick(button: "left")
                }) {
                    Text("Left Click")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    NetworkManager.shared.sendClick(button: "right")
                }) {
                    Text("Right Click")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    TrackpadView()
}
