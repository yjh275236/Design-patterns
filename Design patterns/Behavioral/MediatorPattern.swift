//
//  MediatorPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 中介者模式

protocol Mediator {
    func notify(sender: Colleague, event: String) -> String?
}

protocol Colleague: AnyObject {
    var mediator: Mediator? { get set }
    func send(event: String) -> String?
    func receive(message: String)
}

class ConcreteMediator: Mediator {
    private var colleagues: [Colleague] = []
    
    func addColleague(_ colleague: Colleague) {
        colleagues.append(colleague)
        colleague.mediator = self
    }
    
    func notify(sender: Colleague, event: String) -> String? {
        var result = ""
        for colleague in colleagues {
            if colleague !== sender {
                colleague.receive(message: "收到消息: \(event)")
                result += "消息已发送给其他同事\n"
            }
        }
        return result.isEmpty ? nil : result
    }
}

class ConcreteColleague: Colleague {
    var mediator: Mediator?
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func send(event: String) -> String? {
        return mediator?.notify(sender: self, event: event)
    }
    
    func receive(message: String) {
        print("\(name) \(message)")
    }
}

