//
//  BuilderDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class BuilderDemoViewController: UIViewController {
    
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
        
        let margheritaButton = createButton(title: "制作玛格丽特披萨", action: #selector(makeMargherita))
        let pepperoniButton = createButton(title: "制作意大利辣香肠披萨", action: #selector(makePepperoni))
        let customButton = createButton(title: "自定义披萨", action: #selector(makeCustom))
        
        buttonStackView.addArrangedSubview(margheritaButton)
        buttonStackView.addArrangedSubview(pepperoniButton)
        buttonStackView.addArrangedSubview(customButton)
        
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
        appendOutput("=== 建造者模式演示 ===\n")
        appendOutput("点击按钮创建不同种类的披萨\n")
    }
    
    @objc private func makeMargherita() {
        appendOutput("\n--- 制作玛格丽特披萨 ---")
        let builder = ConcretePizzaBuilder()
        let director = PizzaDirector(builder: builder)
        let pizza = director.makeMargherita()
        appendOutput(pizza.description())
        appendOutput("✅ 披萨制作完成\n")
    }
    
    @objc private func makePepperoni() {
        appendOutput("\n--- 制作意大利辣香肠披萨 ---")
        let builder = ConcretePizzaBuilder()
        let director = PizzaDirector(builder: builder)
        let pizza = director.makePepperoni()
        appendOutput(pizza.description())
        appendOutput("✅ 披萨制作完成\n")
    }
    
    @objc private func makeCustom() {
        appendOutput("\n--- 制作自定义披萨 ---")
        let builder = ConcretePizzaBuilder()
        builder.setDough("薄脆")
        builder.setSauce("白酱")
        builder.setCheese("切达")
        builder.addTopping("蘑菇")
        builder.addTopping("青椒")
        builder.addTopping("洋葱")
        let pizza = builder.build()
        appendOutput(pizza.description())
        appendOutput("✅ 自定义披萨制作完成\n")
    }
    
    private func appendOutput(_ text: String) {
        output += text + "\n"
    }
}

