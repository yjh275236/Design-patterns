//
//  FlyweightDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class FlyweightDemoViewController: UIViewController {
    
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
        
        let createTreesButton = createButton(title: "创建 100 棵树", action: #selector(createTrees))
        let showStatsButton = createButton(title: "显示统计", action: #selector(showStats))
        
        buttonStackView.addArrangedSubview(createTreesButton)
        buttonStackView.addArrangedSubview(showStatsButton)
        
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
        appendOutput("=== 享元模式演示 ===\n")
        appendOutput("共享相同的树类型对象，节省内存\n")
    }
    
    @objc private func createTrees() {
        appendOutput("\n--- 创建 100 棵树 ---")
        var trees: [Tree] = []
        
        for i in 0..<100 {
            let typeName = i % 3 == 0 ? "松树" : (i % 3 == 1 ? "橡树" : "枫树")
            let color = i % 2 == 0 ? "绿色" : "棕色"
            let texture = "纹理\(i % 5)"
            
            let treeType = TreeFactory.getTreeType(name: typeName, color: color, texture: texture)
            let tree = Tree(x: i * 10, y: i * 5, type: treeType)
            trees.append(tree)
        }
        
        appendOutput("创建了 100 棵树")
        appendOutput("树类型对象数量: \(TreeFactory.getTreeCount())")
        appendOutput("\n前 5 棵树的位置:")
        for i in 0..<min(5, trees.count) {
            appendOutput(trees[i].draw())
        }
    }
    
    @objc private func showStats() {
        appendOutput("\n--- 统计信息 ---")
        appendOutput("树类型对象总数: \(TreeFactory.getTreeCount())")
        appendOutput("\n享元模式的好处：")
        appendOutput("- 100 棵树只创建了 \(TreeFactory.getTreeCount()) 个类型对象")
        appendOutput("- 相同类型的树共享同一个 TreeType 实例")
        appendOutput("- 大大减少了内存占用")
    }
    
    private func appendOutput(_ text: String) {
        output += text + "\n"
    }
}

