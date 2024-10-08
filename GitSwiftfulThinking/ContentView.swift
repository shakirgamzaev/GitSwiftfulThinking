//
//  ContentView.swift
//  GitSwiftfulThinking
//
//  Created by shakir Gamzaev on 8/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var color: Color = .red
    
    var body: some View {
        VStack {
            Image(systemName: "heart.fill")
                .font(.largeTitle)
                .foregroundStyle(.blue)
            Text("Swiftful!")
            Button {
                //something
                let newColor = Color(red: Double.random(in: 0..<1), green: Double.random(in: 0..<1), blue: Double.random(in: 0..<1))
                color = newColor
            } label: {
                Text("Subscribe now!")
            }
            Rectangle()
                .fill(color)
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
