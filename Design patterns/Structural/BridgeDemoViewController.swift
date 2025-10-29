//
//  BridgeDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class BridgeDemoViewController: UIViewController {
    
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
        
        let redCircleButton = createButton(title: "红色圆形", action: #selector(drawRedCircle))
        let blueSquareButton = createButton(title: "蓝色正方形", action: #selector(drawBlueSquare))
        let greenCircleButton = createButton(title: "绿色圆形", action: #selector(drawGreenCircle))
        
        buttonStackView.addArrangedSubview(redCircleButton)
        buttonStackView.addArrangedSubview(blueSquareButton)
        buttonStackView.addArrangedSubview(greenCircleButton)
        
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
        appendOutput("=== 桥接模式演示 ===\n")
        appendOutput("形状和颜色可以独立变化\n")
    }
    
    @objc private func drawRedCircle() {
        appendOutput("\n--- 绘制红色圆形 ---")
        let circle = BridgeCircle(color: Red())
        appendOutput(circle.draw())
    }
    
    @objc private func drawBlueSquare() {
        appendOutput("\n--- 绘制蓝色正方形 ---")
        let square = BridgeSquare(color: Blue())
        appendOutput(square.draw())
    }
    
    @objc private func drawGreenCircle() {
        appendOutput("\n--- 绘制绿色圆形 ---")
        let circle = BridgeCircle(color: Green())
        appendOutput(circle.draw())
    }
    
    private func appendOutput(_ text: String) {
        output += text + "\n"
    }
}

