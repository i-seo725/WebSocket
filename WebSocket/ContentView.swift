//
//  ContentView.swift
//  WebSocket
//
//  Created by 이은서 on 12/26/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showNetPage = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("이동하기") {
                showNetPage = true
            }
        }
        .padding()
        .sheet(isPresented: $showNetPage, content: {
            SocketView()
        })
    }
}

#Preview {
    ContentView()
}
