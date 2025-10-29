//
//  PrototypeDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class PrototypeDemoViewController: UIViewController {
    
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
        
        let circleButton = createButton(title: "克隆圆形", action: #selector(cloneCircle))
        let rectangleButton = createButton(title: "克隆矩形", action: #selector(cloneRectangle))
        
        buttonStackView.addArrangedSubview(circleButton)
        buttonStackView.addArrangedSubview(rectangleButton)
        
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
            buttonStackView.heightAnchor.constraint(equalToConstant: 100),
            
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
        appendOutput("=== 原型模式演示 ===\n")
        appendOutput("创建原型对象并克隆它们\n")
    }
    
    @objc private func cloneCircle() {
        appendOutput("\n--- 克隆圆形 ---")
        let original = PrototypeCircle(x: 10, y: 20, color: "红色", radius: 5.0)
        appendOutput("原始对象: \(original.describe())")
        
        let cloned = original.clone()
        cloned.x = 30
        cloned.y = 40
        cloned.color = "蓝色"
        appendOutput("克隆对象: \(cloned.describe())")
        appendOutput("✅ 克隆完成\n")
    }
    
    @objc private func cloneRectangle() {
        appendOutput("\n--- 克隆矩形 ---")
        let original = PrototypeRectangle(x: 50, y: 60, color: "绿色", width: 10.0, height: 20.0)
        appendOutput("原始对象: \(original.describe())")
        
        let cloned = original.clone()
        cloned.x = 70
        cloned.y = 80
        cloned.width = 15.0
        appendOutput("克隆对象: \(cloned.describe())")
        appendOutput("✅ 克隆完成\n")
    }
    
    private func appendOutput(_ text: String) {
        output += text + "\n"
    }
}

