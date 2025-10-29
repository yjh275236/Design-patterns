//
//  InterpreterDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class InterpreterDemoViewController: UIViewController {
    
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
        
        let test1Button = createButton(title: "测试表达式 1", action: #selector(testExpression1))
        let test2Button = createButton(title: "测试表达式 2", action: #selector(testExpression2))
        
        buttonStackView.addArrangedSubview(test1Button)
        buttonStackView.addArrangedSubview(test2Button)
        
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
        appendOutput("=== 解释器模式演示 ===\n")
        appendOutput("解释和执行表达式\n")
    }
    
    @objc private func testExpression1() {
        appendOutput("\n--- 测试表达式: (男人 OR 女人) AND 成年人 ---")
        let man = TerminalExpression(data: "男人")
        let woman = TerminalExpression(data: "女人")
        let adult = TerminalExpression(data: "成年人")
        
        let orExpr = OrExpression(expr1: man, expr2: woman)
        let andExpr = AndExpression(expr1: orExpr, expr2: adult)
        
        let contexts = [
            "这个男人是成年人",
            "这个女人是成年人",
            "这个男孩不是成年人",
            "这个女孩是未成年人"
        ]
        
        for context in contexts {
            let result = andExpr.interpret(context: context)
            appendOutput("'\(context)': \(result ? "匹配" : "不匹配")")
        }
    }
    
    @objc private func testExpression2() {
        appendOutput("\n--- 测试表达式: 苹果 AND 红色 ---")
        let apple = TerminalExpression(data: "苹果")
        let red = TerminalExpression(data: "红色")
        let andExpr = AndExpression(expr1: apple, expr2: red)
        
        let contexts = [
            "红色苹果",
            "绿色苹果",
            "红色樱桃",
            "黄色香蕉"
        ]
        
        for context in contexts {
            let result = andExpr.interpret(context: context)
            appendOutput("'\(context)': \(result ? "匹配" : "不匹配")")
        }
    }
    
    private func appendOutput(_ text: String) {
        output += text + "\n"
    }
}

