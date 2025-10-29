//
//  MementoDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class MementoDemoViewController: UIViewController {
    
    private let outputTextView = UITextView()
    private let buttonStackView = UIStackView()
    
    private var output: String = "" {
        didSet {
            outputTextView.text = output
        }
    }
    
    private let originator = Originator()
    private let caretaker = Caretaker()
    
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
        
        let saveButton = createButton(title: "保存状态", action: #selector(saveState))
        let restoreButton = createButton(title: "恢复状态", action: #selector(restoreState))
        let showStateButton = createButton(title: "显示当前状态", action: #selector(showCurrentState))
        
        buttonStackView.addArrangedSubview(saveButton)
        buttonStackView.addArrangedSubview(restoreButton)
        buttonStackView.addArrangedSubview(showStateButton)
        
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
    
    private var saveCount = 0
    
    private func demonstratePattern() {
        appendOutput("=== 备忘录模式演示 ===\n")
        appendOutput("保存和恢复对象状态\n")
        
        // 设置初始状态
        originator.setState("状态1")
        appendOutput("初始状态: \(originator.getState())")
    }
    
    @objc private func saveState() {
        saveCount += 1
        originator.setState("状态\(saveCount)")
        let memento = originator.saveStateToMemento()
        caretaker.add(memento: memento)
        appendOutput("\n--- 保存状态 ---")
        appendOutput("当前状态: \(originator.getState())")
        appendOutput("已保存到备忘录（历史记录数: \(caretaker.getHistoryCount())）")
    }
    
    @objc private func restoreState() {
        appendOutput("\n--- 恢复状态 ---")
        if let lastMemento = caretaker.get(index: caretaker.getHistoryCount() - 1) {
            originator.getStateFromMemento(memento: lastMemento)
            appendOutput("恢复后的状态: \(originator.getState())")
        } else {
            appendOutput("没有可恢复的状态")
        }
    }
    
    @objc private func showCurrentState() {
        appendOutput("\n--- 当前状态 ---")
        appendOutput("状态: \(originator.getState())")
        appendOutput("历史记录数: \(caretaker.getHistoryCount())")
    }
    
    private func appendOutput(_ text: String) {
        output += text + "\n"
    }
}

