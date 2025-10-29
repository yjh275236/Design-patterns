//
//  IteratorDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class IteratorDemoViewController: UIViewController {
    
    private let outputTextView = UITextView()
    private let iterateButton = UIButton()
    
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
        iterateButton.translatesAutoresizingMaskIntoConstraints = false
        iterateButton.setTitle("遍历姓名列表", for: .normal)
        iterateButton.backgroundColor = .systemBlue
        iterateButton.setTitleColor(.white, for: .normal)
        iterateButton.layer.cornerRadius = 8
        iterateButton.addTarget(self, action: #selector(iterateNames), for: .touchUpInside)
        view.addSubview(iterateButton)
        
        outputTextView.translatesAutoresizingMaskIntoConstraints = false
        outputTextView.isEditable = false
        outputTextView.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        outputTextView.backgroundColor = .systemGray6
        outputTextView.layer.cornerRadius = 8
        view.addSubview(outputTextView)
        
        NSLayoutConstraint.activate([
            iterateButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            iterateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            iterateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            iterateButton.heightAnchor.constraint(equalToConstant: 50),
            
            outputTextView.topAnchor.constraint(equalTo: iterateButton.bottomAnchor, constant: 20),
            outputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            outputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            outputTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func demonstratePattern() {
        appendOutput("=== 迭代器模式演示 ===\n")
        appendOutput("使用迭代器遍历集合元素\n")
    }
    
    @objc private func iterateNames() {
        appendOutput("\n--- 遍历姓名列表 ---")
        let nameRepository = NameRepository()
        let iterator = nameRepository.getIterator()
        
        while iterator.hasNext() {
            if let name = iterator.next() {
                appendOutput("姓名: \(name)")
            }
        }
        appendOutput("\n✅ 遍历完成")
    }
    
    private func appendOutput(_ text: String) {
        output += text + "\n"
    }
}

