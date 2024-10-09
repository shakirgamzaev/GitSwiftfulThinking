//
//  NetworkManager.swift
//  GitSwiftfulThinking
//
//  Created by shakir Gamzaev on 9/10/24.
//

import Foundation
import Network

@MainActor
@Observable
class NetworkManager {
    static let shared = NetworkManager()
    let queue = DispatchQueue(label: "com.Shakir.NetworkQueue")
    var connection: NWConnection
    var connectionState: connectionState = .connecting
    var messages: [Message] = []
    
    init() {
        self.connection = NWConnection(host: "192.168.0.53", port: 55_000, using: .tcp)
        setUpConnection()
    }
    
    func setUpConnection() {
        connection.stateUpdateHandler = {  [weak self] connectionState in
            switch (connectionState) {
            case .preparing:
                DispatchQueue.main.async {
                    self?.connectionState = .connecting
                }
            case .ready:
                DispatchQueue.main.async {
                    self?.connectionState = .ready
                    self?.receiveMessage()
                }
            default:
                DispatchQueue.main.async {
                    self?.connectionState = .other
                }
            }
        }
        connection.start(queue: queue)
    }
    
    func receiveMessage() {
        connection.receive(minimumIncompleteLength: 0, maximumLength: 65535) { data, contentContext, isComplete, error in
            print("data received from server")
            if let data {
                let textFromServer = String(data: data, encoding: .utf8)
                let messageFromServer = Message(isFromUser: false, text: textFromServer ?? "error parsing string from server")
                DispatchQueue.main.async {
                    self.messages.append(messageFromServer)
                }
            }
            DispatchQueue.main.async {
                self.receiveMessage()
            }
        }
    }
    
    func sendTextToServer(text: String) {
        print("text to send: \(text)")
        let textData = text.data(using: .utf8)!
        connection.send(content: textData,completion: .contentProcessed({ error in
            if let error {
                print(error.localizedDescription)
            }
        }))
        receiveMessage()
        
    }
    
    
    enum connectionState {
        case connecting, ready, other
    }
}
