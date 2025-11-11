//
//  InterpreterPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 解释器模式
// 核心角色：Expression 抽象节点定义 interpret，组合节点（And/Or）递归调用子节点
// 新手提示：留意“核心实现”标记理解语法树递归求值，其余部分为简单示例

// 表达式协议，定义解释器的基础接口
protocol Expression {
    // 核心实现：解释输入上下文
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
    
    // 核心实现：终结符节点的判断逻辑
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
    
    // 核心实现：非终结符组合逻辑（或）
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
    
    // 核心实现：非终结符组合逻辑（与）
    func interpret(context: String) -> Bool {
        // 返回两个表达式解释结果的逻辑与
        return expr1.interpret(context: context) && expr2.interpret(context: context)
    }
}

// 使用示例（构建语法树后对输入进行解释）：
// let isJava = TerminalExpression(data: "Java")
// let isKotlin = TerminalExpression(data: "Kotlin")
// let isJavaDev = AndExpression(expr1: isJava, expr2: TerminalExpression(data: "开发"))
// let isBackendLanguage = OrExpression(expr1: isJava, expr2: isKotlin) // 核心：组合表达式
// print(isBackendLanguage.interpret(context: "熟悉Java和Kotlin"))         // true
// print(isJavaDev.interpret(context: "Java 开发工程师"))                  // true

