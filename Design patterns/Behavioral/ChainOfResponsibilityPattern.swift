//
//  ChainOfResponsibilityPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 责任链模式

enum RequestType {
    case purchase
    case refund
    case complaint
}

class Request {
    let type: RequestType
    let amount: Double
    let description: String
    
    init(type: RequestType, amount: Double, description: String) {
        self.type = type
        self.amount = amount
        self.description = description
    }
}

protocol Handler {
    var next: Handler? { get set }
    func handle(request: Request) -> String?
}

class Cashier: Handler {
    var next: Handler?
    
    func handle(request: Request) -> String? {
        if request.type == .purchase && request.amount <= 100 {
            return "收银员处理了购买请求：\(request.description) (金额: ¥\(request.amount))"
        }
        return next?.handle(request: request)
    }
}

class Manager: Handler {
    var next: Handler?
    
    func handle(request: Request) -> String? {
        if request.type == .purchase && request.amount <= 1000 {
            return "经理处理了购买请求：\(request.description) (金额: ¥\(request.amount))"
        } else if request.type == .refund {
            return "经理处理了退款请求：\(request.description) (金额: ¥\(request.amount))"
        }
        return next?.handle(request: request)
    }
}

class Director: Handler {
    var next: Handler?
    
    func handle(request: Request) -> String? {
        if request.type == .purchase {
            return "总监处理了购买请求：\(request.description) (金额: ¥\(request.amount))"
        } else if request.type == .complaint {
            return "总监处理了投诉请求：\(request.description)"
        }
        return next?.handle(request: request) ?? "无法处理该请求"
    }
}

