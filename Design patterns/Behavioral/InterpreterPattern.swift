//
//  InterpreterPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 解释器模式

protocol Expression {
    func interpret(context: String) -> Bool
}

class TerminalExpression: Expression {
    private let data: String
    
    init(data: String) {
        self.data = data
    }
    
    func interpret(context: String) -> Bool {
        return context.contains(data)
    }
}

class OrExpression: Expression {
    private let expr1: Expression
    private let expr2: Expression
    
    init(expr1: Expression, expr2: Expression) {
        self.expr1 = expr1
        self.expr2 = expr2
    }
    
    func interpret(context: String) -> Bool {
        return expr1.interpret(context: context) || expr2.interpret(context: context)
    }
}

class AndExpression: Expression {
    private let expr1: Expression
    private let expr2: Expression
    
    init(expr1: Expression, expr2: Expression) {
        self.expr1 = expr1
        self.expr2 = expr2
    }
    
    func interpret(context: String) -> Bool {
        return expr1.interpret(context: context) && expr2.interpret(context: context)
    }
}

