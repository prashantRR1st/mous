//
//  NetworkManager.swift
//  mous
//
//  Created by Prashant Revaneti on 1/10/26.
//

import Foundation
import Network

class NetworkManager {
    static let shared = NetworkManager()

    // Server configuration
    private let serverIP = "192.168.1.95"
    private let httpPort = 5050
    private let udpPort: UInt16 = 5005

    // Authentication - paste the secret from server's .secret file
    private let authSecret = "PASTE_YOUR_SECRET_HERE"

    // UDP connection for low-latency mouse movement
    private var udpConnection: NWConnection?
    private let udpQueue = DispatchQueue(label: "com.mous.udp")

    private init() {
        setupUDP()
    }

    // MARK: - UDP Setup

    private func setupUDP() {
        let host = NWEndpoint.Host(serverIP)
        let port = NWEndpoint.Port(rawValue: udpPort)!

        udpConnection = NWConnection(host: host, port: port, using: .udp)
        udpConnection?.stateUpdateHandler = { state in
            if case .ready = state {
                print("UDP connection ready")
            }
        }
        udpConnection?.start(queue: udpQueue)
    }

    // MARK: - Mouse Movement (UDP - immediate, no buffering)

    func sendMove(x: CGFloat, y: CGFloat) {
        // Send immediately - format: "secret:dx,dy"
        let message = "\(authSecret):\(x),\(y)"
        if let data = message.data(using: .utf8) {
            udpConnection?.send(content: data, completion: .contentProcessed({ _ in }))
        }
    }

    // MARK: - HTTP Commands (clicks, keyboard)

    private var baseURL: String {
        "http://\(serverIP):\(httpPort)/control"
    }

    private func sendCommand(_ payload: [String: Any]) {
        guard let url = URL(string: baseURL) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(authSecret, forHTTPHeaderField: "X-Auth-Token")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        request.timeoutInterval = 1.0

        URLSession.shared.dataTask(with: request) { _, _, _ in }.resume()
    }

    func sendClick(button: String) {
        sendCommand(["action": "\(button)_click"])
    }

    func sendText(_ text: String) {
        sendCommand(["action": "type", "text": text])
    }

    func sendKey(_ key: String) {
        sendCommand(["action": "key", "key": key])
    }
}
