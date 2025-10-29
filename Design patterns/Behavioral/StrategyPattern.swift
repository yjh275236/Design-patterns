//
//  StrategyPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 策略模式

protocol PaymentStrategy {
    func pay(amount: Double) -> String
}

class CreditCardStrategy: PaymentStrategy {
    private let cardNumber: String
    
    init(cardNumber: String) {
        self.cardNumber = cardNumber
    }
    
    func pay(amount: Double) -> String {
        return "使用信用卡（\(cardNumber)）支付 ¥\(amount)"
    }
}

class WeChatPayStrategy: PaymentStrategy {
    func pay(amount: Double) -> String {
        return "使用微信支付 ¥\(amount)"
    }
}

class AlipayStrategy: PaymentStrategy {
    func pay(amount: Double) -> String {
        return "使用支付宝支付 ¥\(amount)"
    }
}

class ShoppingCart {
    private var items: [String: Double] = [:]
    private var paymentStrategy: PaymentStrategy?
    
    func addItem(name: String, price: Double) {
        items[name] = price
    }
    
    func setPaymentStrategy(_ strategy: PaymentStrategy) {
        self.paymentStrategy = strategy
    }
    
    func checkout() -> String? {
        let total = items.values.reduce(0, +)
        if let strategy = paymentStrategy {
            return strategy.pay(amount: total)
        }
        return "请选择支付方式"
    }
    
    func getTotal() -> Double {
        return items.values.reduce(0, +)
    }
}

