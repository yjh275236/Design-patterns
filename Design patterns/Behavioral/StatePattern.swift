//
//  StatePattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 状态模式

protocol State {
    func handle(context: Context) -> String
}

class Context {
    private var state: State
    
    init(state: State) {
        self.state = state
    }
    
    func setState(_ state: State) {
        self.state = state
    }
    
    func request() -> String {
        return state.handle(context: self)
    }
    
    func getCurrentState() -> String {
        if state is ConcreteStateA {
            return "状态A"
        } else if state is ConcreteStateB {
            return "状态B"
        }
        return "未知状态"
    }
}

class ConcreteStateA: State {
    func handle(context: Context) -> String {
        context.setState(ConcreteStateB())
        return "从状态A转换到状态B"
    }
}

class ConcreteStateB: State {
    func handle(context: Context) -> String {
        context.setState(ConcreteStateA())
        return "从状态B转换到状态A"
    }
}

