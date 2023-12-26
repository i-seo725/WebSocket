//
//  SocketView.swift
//  WebSocket
//
//  Created by 이은서 on 12/26/23.
//

import SwiftUI

struct SocketView: View {
    
    @StateObject
    private var viewModel = SocketViewModel()
    
    var body: some View {
        Text("socketView")
    }
    
}

#Preview {
    SocketView()
}
