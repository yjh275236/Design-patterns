//
//  ProxyDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class ProxyDemoViewController: UIViewController {
    
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
        
        let loadButton = createButton(title: "创建代理（延迟加载）", action: #selector(createProxy))
        let displayButton = createButton(title: "显示图片（触发加载）", action: #selector(displayImage))
        
        buttonStackView.addArrangedSubview(loadButton)
        buttonStackView.addArrangedSubview(displayButton)
        
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
    
    private var imageProxy: ImageProxy?
    
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
        appendOutput("=== 代理模式演示 ===\n")
        appendOutput("代理延迟加载真实图片对象\n")
    }
    
    @objc private func createProxy() {
        appendOutput("\n--- 创建图片代理 ---")
        imageProxy = ImageProxy(filename: "photo.jpg")
        appendOutput("代理对象已创建（真实图片尚未加载）")
    }
    
    @objc private func displayImage() {
        guard let proxy = imageProxy else {
            appendOutput("\n请先创建代理")
            return
        }
        appendOutput("\n--- 显示图片 ---")
        proxy.display()
        appendOutput("✅ 图片加载并显示完成")
    }
    
    private func appendOutput(_ text: String) {
        output += text + "\n"
    }
}

