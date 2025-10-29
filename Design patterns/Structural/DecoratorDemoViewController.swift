//
//  DecoratorDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class DecoratorDemoViewController: UIViewController {
    
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
        
        let simpleButton = createButton(title: "普通咖啡", action: #selector(orderSimple))
        let milkButton = createButton(title: "加牛奶", action: #selector(orderWithMilk))
        let fullButton = createButton(title: "全加（牛奶+糖+奶油）", action: #selector(orderFull))
        
        buttonStackView.addArrangedSubview(simpleButton)
        buttonStackView.addArrangedSubview(milkButton)
        buttonStackView.addArrangedSubview(fullButton)
        
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
    
    private func demonstratePattern() {
        appendOutput("=== 装饰模式演示 ===\n")
        appendOutput("动态添加咖啡的配料\n")
    }
    
    @objc private func orderSimple() {
        appendOutput("\n--- 点单：普通咖啡 ---")
        let coffee = SimpleCoffee()
        appendOutput("\(coffee.description())")
        appendOutput("价格: ¥\(coffee.cost())\n")
    }
    
    @objc private func orderWithMilk() {
        appendOutput("\n--- 点单：咖啡加牛奶 ---")
        var coffee: Coffee = SimpleCoffee()
        coffee = MilkDecorator(coffee: coffee)
        appendOutput("\(coffee.description())")
        appendOutput("价格: ¥\(coffee.cost())\n")
    }
    
    @objc private func orderFull() {
        appendOutput("\n--- 点单：全加咖啡 ---")
        var coffee: Coffee = SimpleCoffee()
        coffee = MilkDecorator(coffee: coffee)
        coffee = SugarDecorator(coffee: coffee)
        coffee = WhipDecorator(coffee: coffee)
        appendOutput("\(coffee.description())")
        appendOutput("价格: ¥\(coffee.cost())\n")
    }
    
    private func appendOutput(_ text: String) {
        output += text + "\n"
    }
}

