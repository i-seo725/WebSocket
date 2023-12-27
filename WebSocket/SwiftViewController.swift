//
//  SwiftViewController.swift
//  WebSocket
//
//  Created by 이은서 on 12/27/23.
//

import UIKit

let age = Int.random(in: 1...100)


class SwiftViewController: UIViewController {

    let status = true
    let views = SeSACFactory.make(.label)

    //새로운 문법
    let randomResult = if age < 20 { "학생" }
    else if age > 31 && age < 60 { "어른" }
    else { "노인" }
    
    lazy var userStatus = if status { UIColor.black }
    else { UIColor.red }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let result = exampleGeneric(a: "11", "22", "33")
        result.1
    }
    
    func randomAge() -> String {
        switch age {
        case 1...30: return "학생"
        case 31...60: return "어른"
        case 61...100: return "노인"
        default: return "알 수 없음"
        }
    }

    //iOS 15.0 ~ 16.4 버전까지만 사용하겠다
//    @backDeployed(before: iOS 16.4) 해당 버전 이하까지 사용
    @available(iOS 15.0, *)
    func randomAge2() -> String {
        if age < 30 {
            return "학생"
        } else if age < 31 && age < 60 {
            return "어른"
        } else {
            return "노인"
        }
    }
    
    //generic 옵셔널 사용 가능해짐, 원래 안됐음
    func example<T, K>(a: T, b: K?) -> String {
        return "\(a)"
    }
    
    //같은 타입으로 여러 개의 매개변수를 받기 위해 each T, repeat 키워드 사용
    //tuple 구조에 넣어서 사용
    func exampleGeneric<each T>(a: repeat (each T)) -> (repeat each T) {
        print((repeat each a))
        return (repeat each a)
    }
    
}

enum SeSACComponent {
    case label
    case button
}

protocol SeSACUIComponent {
    var component: SeSACComponent { get }
    var color: UIColor { get set }
    var bgColor: UIColor { get set }
}

final class NewLabel: UILabel, SeSACUIComponent {
    var component: SeSACComponent = .label
    var color: UIColor
    var bgColor: UIColor
    
    init(color: UIColor, bgColor: UIColor) {
        self.color = color
        self.bgColor = bgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class SeSACLabel: UILabel {
    
    init(textColor: UIColor, bgColor: UIColor) {
        super.init(frame: .zero)
        
        self.textColor = textColor
        self.backgroundColor = bgColor
    }
    
    init(font: UIFont, bgColor: UIColor) {
        super.init(frame: .zero)
        
        self.font = font
        self.backgroundColor = bgColor
        self.numberOfLines = 0
        self.textColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//DTO
struct SeSACFactory {
    
    static func make(_ component: SeSACComponent) -> SeSACUIComponent {
        switch component {
        case .label:
            return NewLabel(color: .blue, bgColor: .white)
        default:
            return NewLabel(color: .blue, bgColor: .white)
        }
    }
    
}
