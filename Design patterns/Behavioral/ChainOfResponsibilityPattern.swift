//
//  ChainOfResponsibilityPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 责任链模式

// 请求类型枚举，定义不同类型的请求
enum RequestType {
    // 购买请求
    case purchase
    // 退款请求
    case refund
    // 投诉请求
    case complaint
}

// 请求类，封装请求的详细信息
class Request {
    // 请求类型
    let type: RequestType
    // 请求金额
    let amount: Double
    // 请求描述
    let description: String
    
    // 初始化方法，设置请求的属性
    init(type: RequestType, amount: Double, description: String) {
        // 设置请求类型
        self.type = type
        // 设置请求金额
        self.amount = amount
        // 设置请求描述
        self.description = description
    }
}

// 处理器协议，定义责任链中的处理节点
protocol Handler {
    // 下一个处理器引用（可选）
    var next: Handler? { get set }
    // 处理请求的方法，返回处理结果或nil（表示传递给下一个处理器）
    func handle(request: Request) -> String?
}

// 收银员类，实现Handler协议，处理小额购买请求
class Cashier: Handler {
    // 下一个处理器引用
    var next: Handler?
    
    // 实现handle方法，处理请求
    func handle(request: Request) -> String? {
        // 如果是购买请求且金额不超过100，由收银员处理
        if request.type == .purchase && request.amount <= 100 {
            // 返回处理结果
            return "收银员处理了购买请求：\(request.description) (金额: ¥\(request.amount))"
        }
        // 如果不能处理，传递给下一个处理器
        return next?.handle(request: request)
    }
}

// 经理类，实现Handler协议，处理中等金额的购买和退款请求
class Manager: Handler {
    // 下一个处理器引用
    var next: Handler?
    
    // 实现handle方法，处理请求
    func handle(request: Request) -> String? {
        // 如果是购买请求且金额不超过1000，由经理处理
        if request.type == .purchase && request.amount <= 1000 {
            // 返回处理结果
            return "经理处理了购买请求：\(request.description) (金额: ¥\(request.amount))"
        } else if request.type == .refund {
            // 如果是退款请求，由经理处理
            return "经理处理了退款请求：\(request.description) (金额: ¥\(request.amount))"
        }
        // 如果不能处理，传递给下一个处理器
        return next?.handle(request: request)
    }
}

// 总监类，实现Handler协议，处理大额购买和投诉请求
class Director: Handler {
    // 下一个处理器引用
    var next: Handler?
    
    // 实现handle方法，处理请求
    func handle(request: Request) -> String? {
        // 如果是购买请求，由总监处理
        if request.type == .purchase {
            // 返回处理结果
            return "总监处理了购买请求：\(request.description) (金额: ¥\(request.amount))"
        } else if request.type == .complaint {
            // 如果是投诉请求，由总监处理
            return "总监处理了投诉请求：\(request.description)"
        }
        // 如果不能处理，传递给下一个处理器，如果链已结束则返回无法处理的消息
        return next?.handle(request: request) ?? "无法处理该请求"
    }
}

