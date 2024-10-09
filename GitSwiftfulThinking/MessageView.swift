//
//  MessageView.swift
//  GitSwiftfulThinking
//
//  Created by shakir Gamzaev on 9/10/24.
//

import SwiftUI

struct Message: Identifiable {
    var isFromUser: Bool
    var text: String
    var id = UUID()
}



struct MessageView: View {
    @State private var text = ""
    @State private var networkManager = NetworkManager.shared
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVStack {
                    ForEach(networkManager.messages) { message in
                        MessageTextView(message: message)
                    }
                }
            }
            .safeAreaPadding(.bottom, 100)
            
            VStack {
                TextField("message", text: $text, prompt: Text("Enter message"))
                    .padding()
                    .background(Color(uiColor: .systemGray5), in: .rect(cornerRadius: 10))
                    .onSubmit {
                        networkManager.messages.append(Message(isFromUser: true, text: text))
                        if networkManager.connectionState == .ready {
                            networkManager.sendTextToServer(text: text)
                        }
                        text = ""
                    }
            }
            .padding()
            .background {
                Color(uiColor: .systemBackground).ignoresSafeArea()
            }
            
            Circle()
                .fill(networkManager.connectionState == .ready ? .green : .red)
                .frame(width: 30, height: 30)
                .frame(maxHeight: .infinity,alignment: .top)
        }
    }
}

struct MessageTextView: View {
    let message: Message
    
    var body: some View {
        Text(message.text)
            .padding()
            .frame(width: 200)
            .frame(maxWidth: .infinity,alignment: message.isFromUser ? .trailing : .leading)
    }
}

#Preview {
    MessageView()
}
