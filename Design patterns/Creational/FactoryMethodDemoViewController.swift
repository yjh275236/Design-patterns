//
//  FactoryMethodDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class FactoryMethodDemoViewController: UIViewController {
    
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
        
        let roadButton = createButton(title: "陆路运输", action: #selector(roadDelivery))
        let seaButton = createButton(title: "海运", action: #selector(seaDelivery))
        let airButton = createButton(title: "空运", action: #selector(airDelivery))
        
        buttonStackView.addArrangedSubview(roadButton)
        buttonStackView.addArrangedSubview(seaButton)
        buttonStackView.addArrangedSubview(airButton)
        
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
        appendOutput("=== 工厂方法模式演示 ===\n")
        appendOutput("点击上方按钮选择不同的运输方式\n")
    }
    
    @objc private func roadDelivery() {
        appendOutput("\n--- 陆路运输 ---")
        let logistics = RoadLogistics()
        logistics.planDelivery()
        appendOutput("✅ 运输完成\n")
    }
    
    @objc private func seaDelivery() {
        appendOutput("\n--- 海运 ---")
        let logistics = SeaLogistics()
        logistics.planDelivery()
        appendOutput("✅ 运输完成\n")
    }
    
    @objc private func airDelivery() {
        appendOutput("\n--- 空运 ---")
        let logistics = AirLogistics()
        logistics.planDelivery()
        appendOutput("✅ 运输完成\n")
    }
    
    private func appendOutput(_ text: String) {
        output += text + "\n"
    }
}

