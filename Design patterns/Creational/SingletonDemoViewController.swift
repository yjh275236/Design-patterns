//
//  SingletonDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class SingletonDemoViewController: UIViewController {
    
    private let outputTextView = UITextView()
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
        outputTextView.translatesAutoresizingMaskIntoConstraints = false
        outputTextView.isEditable = false
        outputTextView.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        outputTextView.backgroundColor = .systemGray6
        outputTextView.layer.cornerRadius = 8
        view.addSubview(outputTextView)
        
        NSLayoutConstraint.activate([
            outputTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            outputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            outputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            outputTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func demonstratePattern() {
        appendOutput("=== 单例模式演示 ===\n")
        
        // 多次获取实例，都是同一个对象
        let db1 = DatabaseManager.shared
        appendOutput("获取 DatabaseManager 实例 1")
        
        let db2 = DatabaseManager.shared
        appendOutput("获取 DatabaseManager 实例 2")
        
        appendOutput("db1 === db2: \(db1 === db2)\n")
        
        db1.connect()
        db2.connect()
        db1.connect()
        
        appendOutput("\n连接数: \(db1.getConnectionCount())")
    }
    
    private func appendOutput(_ text: String) {
        output += text + "\n"
    }
}

