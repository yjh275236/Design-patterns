//
//  ChainOfResponsibilityDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class ChainOfResponsibilityDemoViewController: UIViewController {
    
    private let outputTextView = UITextView()
    private let buttonStackView = UIStackView()
    
    private var output: String = "" {
        didSet {
            outputTextView.text = output
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        demonstratePattern()
    }
    
    private func setupUI() {
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 10
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)
        
        let smallButton = createButton(title: "小金额购买 (¥50)", action: #selector(handleSmallPurchase))
        let mediumButton = createButton(title: "中金额购买 (¥500)", action: #selector(handleMediumPurchase))
        let refundButton = createButton(title: "退款请求", action: #selector(handleRefund))
        
        buttonStackView.addArrangedSubview(smallButton)
        buttonStackView.addArrangedSubview(mediumButton)
        buttonStackView.addArrangedSubview(refundButton)
        
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
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setupChain() -> Handler {
        let cashier = Cashier()
        let manager = Manager()
        let director = Director()
        
        cashier.next = manager
        manager.next = director
        
        return cashier
    }
    
    private func demonstratePattern() {
        appendOutput("=== 责任链模式演示 ===\n")
        appendOutput("请求沿着处理链传递直到被处理\n")
    }
    
    @objc private func handleSmallPurchase() {
        appendOutput("\n--- 处理小金额购买 ---")
        let chain = setupChain()
        let request = Request(type: .purchase, amount: 50, description: "购买商品A")
        if let result = chain.handle(request: request) {
            appendOutput(result)
        }
    }
    
    @objc private func handleMediumPurchase() {
        appendOutput("\n--- 处理中金额购买 ---")
        let chain = setupChain()
        let request = Request(type: .purchase, amount: 500, description: "购买商品B")
        if let result = chain.handle(request: request) {
            appendOutput(result)
        }
    }
    
    @objc private func handleRefund() {
        appendOutput("\n--- 处理退款请求 ---")
        let chain = setupChain()
        let request = Request(type: .refund, amount: 200, description: "退款申请")
        if let result = chain.handle(request: request) {
            appendOutput(result)
        }
    }
    
    private func appendOutput(_ text: String) {
        output += text + "\n"
    }
}

