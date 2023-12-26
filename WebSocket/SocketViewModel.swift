//
//  SocketViewModel.swift
//  WebSocket
//
//  Created by 이은서 on 12/26/23.
//

import Foundation

class SocketViewModel: ObservableObject {
    
    init() {
        WebSocketManager.shared.openWebSocket()
        WebSocketManager.shared.send()
    }
    
    deinit {
        WebSocketManager.shared.closeWebSocket()
    }
    
}
