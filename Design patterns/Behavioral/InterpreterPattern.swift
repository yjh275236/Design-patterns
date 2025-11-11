//
//  InterpreterPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 解释器模式

// 表达式协议，定义解释器的基础接口
protocol Expression {
    // 解释方法，接收上下文字符串，返回布尔值
    func interpret(context: String) -> Bool
}

// 终结符表达式类，实现Expression协议，表示单个词的匹配
class TerminalExpression: Expression {
    // 私有属性：要匹配的数据（词）
    private let data: String
    
    // 初始化方法，设置要匹配的数据
    init(data: String) {
        // 保存要匹配的数据
        self.data = data
    }
    
    // 实现interpret方法，检查上下文是否包含该数据
    func interpret(context: String) -> Bool {
        // 返回上下文是否包含要匹配的数据
        return context.contains(data)
    }
}

// 或表达式类，实现Expression协议，表示逻辑或关系
class OrExpression: Expression {
    // 私有属性：第一个表达式
    private let expr1: Expression
    // 私有属性：第二个表达式
    private let expr2: Expression
    
    // 初始化方法，设置两个表达式
    init(expr1: Expression, expr2: Expression) {
        // 保存第一个表达式
        self.expr1 = expr1
        // 保存第二个表达式
        self.expr2 = expr2
    }
    
    // 实现interpret方法，执行逻辑或操作
    func interpret(context: String) -> Bool {
        // 返回两个表达式解释结果的逻辑或
        return expr1.interpret(context: context) || expr2.interpret(context: context)
    }
}

// 与表达式类，实现Expression协议，表示逻辑与关系
class AndExpression: Expression {
    // 私有属性：第一个表达式
    private let expr1: Expression
    // 私有属性：第二个表达式
    private let expr2: Expression
    
    // 初始化方法，设置两个表达式
    init(expr1: Expression, expr2: Expression) {
        // 保存第一个表达式
        self.expr1 = expr1
        // 保存第二个表达式
        self.expr2 = expr2
    }
    
    // 实现interpret方法，执行逻辑与操作
    func interpret(context: String) -> Bool {
        // 返回两个表达式解释结果的逻辑与
        return expr1.interpret(context: context) && expr2.interpret(context: context)
    }
}

