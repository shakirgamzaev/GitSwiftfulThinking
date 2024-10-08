//
//  Home.swift
//  GitSwiftfulThinking
//
//  Created by shakir Gamzaev on 8/10/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        List {
            ForEach(0..<10) { _ in
                Rectangle()
                    .frame(height: 200)
            }
        }
    }
}

#Preview {
    Home()
}
