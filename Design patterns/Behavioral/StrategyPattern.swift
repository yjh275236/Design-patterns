//
//  StrategyPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 策略模式

// 支付策略协议，定义支付策略的接口
protocol PaymentStrategy {
    // 支付方法，接收支付金额，返回支付信息
    func pay(amount: Double) -> String
}

// 信用卡支付策略类，实现PaymentStrategy协议
class CreditCardStrategy: PaymentStrategy {
    // 私有属性：信用卡号
    private let cardNumber: String
    
    // 初始化方法，设置信用卡号
    init(cardNumber: String) {
        // 保存信用卡号
        self.cardNumber = cardNumber
    }
    
    // 实现pay方法，执行信用卡支付
    func pay(amount: Double) -> String {
        // 返回信用卡支付信息，包含卡号和金额
        return "使用信用卡（\(cardNumber)）支付 ¥\(amount)"
    }
}

// 微信支付策略类，实现PaymentStrategy协议
class WeChatPayStrategy: PaymentStrategy {
    // 实现pay方法，执行微信支付
    func pay(amount: Double) -> String {
        // 返回微信支付信息，包含金额
        return "使用微信支付 ¥\(amount)"
    }
}

// 支付宝支付策略类，实现PaymentStrategy协议
class AlipayStrategy: PaymentStrategy {
    // 实现pay方法，执行支付宝支付
    func pay(amount: Double) -> String {
        // 返回支付宝支付信息，包含金额
        return "使用支付宝支付 ¥\(amount)"
    }
}

// 购物车类，使用支付策略来处理支付
class ShoppingCart {
    // 私有属性：存储商品名称和价格的字典
    private var items: [String: Double] = [:]
    // 私有属性：当前选择的支付策略（可选）
    private var paymentStrategy: PaymentStrategy?
    
    // 添加商品的方法
    func addItem(name: String, price: Double) {
        // 将商品添加到字典中
        items[name] = price
    }
    
    // 设置支付策略的方法
    func setPaymentStrategy(_ strategy: PaymentStrategy) {
        // 保存支付策略引用
        self.paymentStrategy = strategy
    }
    
    // 结账方法，使用设置的支付策略进行支付
    func checkout() -> String? {
        // 计算所有商品的总价
        let total = items.values.reduce(0, +)
        // 检查是否设置了支付策略
        if let strategy = paymentStrategy {
            // 如果设置了策略，使用策略进行支付
            return strategy.pay(amount: total)
        }
        // 如果没有设置策略，提示用户选择支付方式
        return "请选择支付方式"
    }
    
    // 获取总价的方法
    func getTotal() -> Double {
        // 计算并返回所有商品的总价
        return items.values.reduce(0, +)
    }
}

