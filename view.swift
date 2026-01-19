import SwiftUI
import Network

struct ConstentView: View {
	@State private var connection: NXConnection?
	let host: NWEndpoint.Host = "192.168.1.XX" // Mac's local IP
	let port: NWEndpoint.Port = 5005

	var body: some View {
		Rectangle()
			.fill(Color.gray.opacity(0.2))
			.gesture(
				DragGesture()
					.onChanged { value in
						// Calculate movement since last update
						let dx = value.translation.width
						let dy = value.translation.height
						sendData(message: "\(dx),\(dy)")
					}
			)
			.onAppear(perform: connect)
	}
	
	func connect() {
		connection = NWConnection(host: host, port: port, using: .udp)
		connection?.start(queue: .global())
	}
	
	func sendData(message: String) {
		let data = message.data(using: .utf8)
		connection?.send(content: data, completion: .contentProcessed({ _ in }))
	}
}
