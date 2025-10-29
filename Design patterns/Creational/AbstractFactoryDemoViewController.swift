//
//  AbstractFactoryDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class AbstractFactoryDemoViewController: UIViewController {
    
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
        
        let macButton = createButton(title: "Mac UI 风格", action: #selector(createMacUI))
        let windowsButton = createButton(title: "Windows UI 风格", action: #selector(createWindowsUI))
        
        buttonStackView.addArrangedSubview(macButton)
        buttonStackView.addArrangedSubview(windowsButton)
        
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
        appendOutput("=== 抽象工厂模式演示 ===\n")
        appendOutput("点击按钮创建不同风格的 UI 组件\n")
    }
    
    @objc private func createMacUI() {
        appendOutput("\n--- 创建 Mac UI ---")
        let factory = MacUIFactory()
        let button = factory.createButton()
        let checkbox = factory.createCheckbox()
        button.render()
        checkbox.render()
        appendOutput("✅ Mac UI 组件创建完成\n")
    }
    
    @objc private func createWindowsUI() {
        appendOutput("\n--- 创建 Windows UI ---")
        let factory = WindowsUIFactory()
        let button = factory.createButton()
        let checkbox = factory.createCheckbox()
        button.render()
        checkbox.render()
        appendOutput("✅ Windows UI 组件创建完成\n")
    }
    
    private func appendOutput(_ text: String) {
        output += text + "\n"
    }
}

