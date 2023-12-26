//
//  WebSocketManager.swift
//  WebSocket
//
//  Created by 이은서 on 12/26/23.
//

import Foundation

//채택한 WebSoketDelegate가 따라가면 NSObjectProtocol을 따르기 때문에 NSObject를 상속받아야 함
final class WebSocketManager: NSObject {
    
    static let shared = WebSocketManager()
    
    //상속받아서 override 키워드 필요해짐
    private override init() {
        super.init() //NSObject의 init
    }
    
    private var webSocket: URLSessionWebSocketTask?
    private var timer: Timer?
    private var isOpen = false //소켓 연결 상태
    
    //소켓 열기 요청
    func openWebSocket() {
        //소켓 연결 시 데이터를 completion으로 받기는 어려움
        if let url = URL(string: "wss://api.upbit.com/websocket/v1") {
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            webSocket = session.webSocketTask(with: url)
            webSocket?.resume()
            
            ping()
        }
    }
    
    //소켓 닫기 요청
    func closeWebSocket() {
        
        //URLSessionWebSocketTask Enum Close Code
        webSocket?.cancel(with: .goingAway, reason: nil)
        webSocket = nil
        
        timer?.invalidate()
        timer = nil
        
        isOpen = false
    }
    
    func send() {
        let string = """
        [{"ticket":"test"},{"type":"orderbook","codes":["KRW-BTC"]}]
        """
        webSocket?.send(.string(string), completionHandler: { error in
            if let error {
                print("send error ", error)
            }
        })
    }
    
    func receive() {
        
        if isOpen { //소켓이 열린 상태에서만 데이터 받게 하기
            webSocket?.receive(completionHandler: { [weak self] result in
                switch result {
                case .success(let success):
//                    print("success ", success)
                    
                    switch success {
                    case .data(let data):
                        if let decodeData = try? JSONDecoder().decode(OrderBookWS.self, from: data) {
                            print("receive \(decodeData)")
                        }
                    case .string(let string): print(string)
                    @unknown default: print("unknown error")
                    }
                    
                case .failure(let failure):
                    print("failure ", failure)
                }
                self?.receive() //WWDC Websocket 구성 가이드, self 키워드로 캡쳐 돼서 weak self
            })
        }
        

    }
    
    //서버에 의해연결이 끊어지지 않도록 주기적으로 서버에 ping 전송
    private func ping() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] _ in
            self?.webSocket?.sendPing(pongReceiveHandler: { error in
                if let error {
                    print("PingPong Error")
                } else {
                    print("Ping")
                }
            })
        })
        
    }
    
}

//URLSessionWebSocketDelegate가 타고 타고 가면 URLSessionDelegate를 채택함
extension WebSocketManager: URLSessionWebSocketDelegate {
    
    //didOpen : 웹소켓 연결이 되었는 지 확인
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("OPEN")
        isOpen = true
        receive()
    }
    
    //didClose : 웹소켓 연결이 해제되었는 지 확인
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        isOpen = false
        print("CLOSE")
    }
    
    
   
}
