//
//  FacadeDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class FacadeDemoViewController: UIViewController {
    
    private let outputTextView = UITextView()
    private let startButton = UIButton()
    
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
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.setTitle("启动计算机", for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 8
        startButton.addTarget(self, action: #selector(startComputer), for: .touchUpInside)
        view.addSubview(startButton)
        
        outputTextView.translatesAutoresizingMaskIntoConstraints = false
        outputTextView.isEditable = false
        outputTextView.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        outputTextView.backgroundColor = .systemGray6
        outputTextView.layer.cornerRadius = 8
        view.addSubview(outputTextView)
        
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            
            outputTextView.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            outputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            outputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            outputTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func demonstratePattern() {
        appendOutput("=== 外观模式演示 ===\n")
        appendOutput("点击按钮启动计算机（隐藏复杂的子系统）\n")
    }
    
    @objc private func startComputer() {
        let computer = ComputerFacade()
        computer.start()
        appendOutput("\n外观模式简化了启动过程，用户无需了解 CPU、内存、硬盘的细节")
    }
    
    private func appendOutput(_ text: String) {
        output += text + "\n"
    }
}

