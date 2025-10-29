//
//  StrategyDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class StrategyDemoViewController: UIViewController {
    
    private let outputTextView = UITextView()
    private let buttonStackView = UIStackView()
    
    private var output: String = "" {
        didSet {
            outputTextView.text = output
        }
    }
    
    private let cart = ShoppingCart()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupCart()
        demonstratePattern()
    }
    
    private func setupUI() {
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 10
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)
        
        let wechatButton = createButton(title: "微信支付", action: #selector(payWithWeChat))
        let alipayButton = createButton(title: "支付宝支付", action: #selector(payWithAlipay))
        let creditButton = createButton(title: "信用卡支付", action: #selector(payWithCredit))
        
        buttonStackView.addArrangedSubview(wechatButton)
        buttonStackView.addArrangedSubview(alipayButton)
        buttonStackView.addArrangedSubview(creditButton)
        
        outputTextView.translatesAutoresizingMaskIntoConstraints = false
        outputTextView.isEditable = false
        outputTextView.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        outputTextView.backgroundColor = .systemGray6
        outputTextView.layer.cornerRadius = 8
        view.addSubview(outputTextView)
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 150),
            
            outputTextView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20),
            outputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            outputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            outputTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupCart() {
        cart.addItem(name: "商品A", price: 100.0)
        cart.addItem(name: "商品B", price: 200.0)
        cart.addItem(name: "商品C", price: 150.0)
    }
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func demonstratePattern() {
        appendOutput("=== 策略模式演示 ===\n")
        appendOutput("购物车总金额: ¥\(cart.getTotal())")
        appendOutput("选择不同的支付策略\n")
    }
    
    @objc private func payWithWeChat() {
        appendOutput("\n--- 微信支付 ---")
        cart.setPaymentStrategy(WeChatPayStrategy())
        if let result = cart.checkout() {
            appendOutput(result)
        }
    }
    
    @objc private func payWithAlipay() {
        appendOutput("\n--- 支付宝支付 ---")
        cart.setPaymentStrategy(AlipayStrategy())
        if let result = cart.checkout() {
            appendOutput(result)
        }
    }
    
    @objc private func payWithCredit() {
        appendOutput("\n--- 信用卡支付 ---")
        cart.setPaymentStrategy(CreditCardStrategy(cardNumber: "****1234"))
        if let result = cart.checkout() {
            appendOutput(result)
        }
    }
    
    private func appendOutput(_ text: String) {
        output += text + "\n"
    }
}

