//
//  SocketViewModel.swift
//  WebSocket
//
//  Created by 이은서 on 12/26/23.
//

import Foundation
import Combine

class SocketViewModel: ObservableObject {
    
    @Published
      var askOrderBook: [OrderbookItem] = []
    @Published
      var bidOrderBook: [OrderbookItem] = []
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        WebSocketManager.shared.openWebSocket()
        WebSocketManager.shared.send()
        
        //RxSwift Subscribe, Disposed, Main Scheduler 필요
        //RxSwift subscribe vs Combine sink
        //RxSwift scheduler vs Combine receive
        //RxSwift Dispose vs Combine AnyCancellable
        WebSocketManager.shared.orderBookSbj
            .receive(on: DispatchQueue.main)
            .sink { [weak self] order in
                guard let self else { return }
                        self.askOrderBook = order.orderbookUnits
                          .map { .init(price: $0.askPrice, size: $0.askSize) }
                          .sorted { $0.price > $1.price }
                        self.bidOrderBook = order.orderbookUnits
                          .map { .init(price: $0.bidPrice, size: $0.bidSize) }
                          .sorted { $0.price > $1.price }
            }
            .store(in: &cancellable)
    }
    
    deinit {
        WebSocketManager.shared.closeWebSocket()
    }
    
}
