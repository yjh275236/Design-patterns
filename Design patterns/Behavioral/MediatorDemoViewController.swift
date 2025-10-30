//
//  MediatorDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class MediatorDemoViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let descriptionLabel = UILabel()
    private let outputTextView = UITextView()
    private let buttonStackView = UIStackView()
    private let clearButton = UIButton(type: .system)
    
    private var descriptionHeightConstraint: NSLayoutConstraint!
    private var isDescriptionVisible = true
    private var isAnimating = false
    private var descriptionFullHeight: CGFloat = 180
    private let scrollThreshold: CGFloat = 100
    private var lastScrollOffset: CGFloat = 0
    private var hideTimestamp: Date?
    private let restoreCooldown: TimeInterval = 0.5
    private var scrollViewReenableTimer: Timer?
    private var lastContentInsetBottom: CGFloat = 0
    
    private var output: String = "" {
        didSet {
            outputTextView.text = output
            scrollToBottom()
        }
    }
    
    private let mediator = ConcreteMediator()
    private var colleague1: ConcreteColleague?
    private var colleague2: ConcreteColleague?
    private var colleague3: ConcreteColleague?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupMediator()
        demonstratePattern()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        outputTextView.textContainer.heightTracksTextView = false
        guard !outputTextView.isDragging && !outputTextView.isDecelerating else { return }
        if outputTextView.contentSize.height <= outputTextView.bounds.height {
            let extraHeight = max(1, outputTextView.bounds.height - outputTextView.contentSize.height + 1)
            if abs(extraHeight - lastContentInsetBottom) > 0.5 {
                outputTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: extraHeight, right: 0)
                lastContentInsetBottom = extraHeight
            }
        } else if lastContentInsetBottom > 0 {
            outputTextView.contentInset = .zero
            lastContentInsetBottom = 0
        }
    }
    
    deinit {
        scrollViewReenableTimer?.invalidate()
        scrollViewReenableTimer = nil
    }
    
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.bounces = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 15)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.text = """
        📋 中介者模式 (Mediator)
        
        💡 定义：用一个中介对象来封装一系列的对象交互。
        
        🎯 用途：
        • 降低对象之间的直接耦合
        • 简化对象间的交互
        • 集中控制交互逻辑
        
        🏗️ 结构：
        Mediator（中介者接口）
        └── ConcreteMediator（具体中介者）
        Colleague（同事接口）
        └── ConcreteColleague（具体同事）
        
        ⚙️ 执行流程：同事通过中介者通信，而非直接交互
        """
        descriptionLabel.clipsToBounds = true
        contentView.addSubview(descriptionLabel)
        
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 12
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonStackView)
        
        let send1Button = createButton(title: "同事1发送消息", action: #selector(sendMessage1))
        let send2Button = createButton(title: "同事2发送消息", action: #selector(sendMessage2))
        
        buttonStackView.addArrangedSubview(send1Button)
        buttonStackView.addArrangedSubview(send2Button)
        
        clearButton.setTitle("清除输出", for: .normal)
        clearButton.backgroundColor = .systemGray3
        clearButton.setTitleColor(.label, for: .normal)
        clearButton.layer.cornerRadius = 8
        clearButton.addTarget(self, action: #selector(clearOutput), for: .touchUpInside)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(clearButton)
        
        outputTextView.translatesAutoresizingMaskIntoConstraints = false
        outputTextView.isEditable = false
        outputTextView.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        outputTextView.backgroundColor = .systemGray6
        outputTextView.layer.cornerRadius = 8
        outputTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        outputTextView.isScrollEnabled = true
        contentView.addSubview(outputTextView)
        
        let descriptionWidth = UIScreen.main.bounds.width - 40
        descriptionLabel.preferredMaxLayoutWidth = descriptionWidth
        descriptionFullHeight = descriptionLabel.systemLayoutSizeFitting(CGSize(width: descriptionWidth, height: UIView.layoutFittingExpandedSize.height)).height
        descriptionHeightConstraint = descriptionLabel.heightAnchor.constraint(equalToConstant: descriptionFullHeight)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionHeightConstraint,
            
            buttonStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 100),
            
            clearButton.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 8),
            clearButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            clearButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            clearButton.heightAnchor.constraint(equalToConstant: 40),
            
            outputTextView.topAnchor.constraint(equalTo: clearButton.bottomAnchor, constant: 12),
            outputTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            outputTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            outputTextView.heightAnchor.constraint(equalToConstant: 500),
            outputTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupMediator() {
        colleague1 = ConcreteColleague(name: "同事1")
        colleague2 = ConcreteColleague(name: "同事2")
        colleague3 = ConcreteColleague(name: "同事3")
        
        mediator.addColleague(colleague1!)
        mediator.addColleague(colleague2!)
        mediator.addColleague(colleague3!)
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
        appendOutput("═══════════════════════════════════════")
        appendOutput("  中介者模式演示")
        appendOutput("═══════════════════════════════════════")
        appendOutput("📝 中介者模式降低对象之间的直接耦合")
        appendOutput("💡 通过中介者协调对象间的通信")
        appendOutput("请点击上方按钮测试同事间的消息传递")
    }
    
    @objc private func sendMessage1() {
        appendOutput("\n--- 同事1发送消息 ---")
        appendOutput("  步骤1: 同事1准备发送消息")
        appendOutput("  步骤2: 通过中介者发送（而非直接发送给其他同事）")
        if let result = colleague1?.send(event: "大家好，我是同事1") {
            appendOutput("  \(result)")
        }
        appendOutput("✅ 中介者模式：同事通过中介者通信")
    }
    
    @objc private func sendMessage2() {
        appendOutput("\n--- 同事2发送消息 ---")
        appendOutput("  步骤1: 同事2准备发送消息")
        appendOutput("  步骤2: 通过中介者发送（而非直接发送给其他同事）")
        if let result = colleague2?.send(event: "大家好，我是同事2") {
            appendOutput("  \(result)")
        }
        appendOutput("✅ 中介者模式：同事通过中介者通信")
    }
    
    @objc private func clearOutput() {
        output = ""
        demonstratePattern()
    }
    
    private func appendOutput(_ text: String) {
        output += text + "\n"
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.async {
            let bottom = self.outputTextView.contentSize.height - self.outputTextView.bounds.height
            if bottom > 0 {
                self.outputTextView.setContentOffset(CGPoint(x: 0, y: bottom), animated: true)
            }
        }
    }
    
    private func toggleDescription(visible: Bool) {
        guard !isAnimating && isDescriptionVisible != visible else { return }
        
        isAnimating = true
        isDescriptionVisible = visible
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            if visible {
                self.descriptionHeightConstraint.constant = self.descriptionFullHeight
            } else {
                self.descriptionHeightConstraint.constant = 0
            }
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.isAnimating = false
            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
                
                if !visible {
                    self.hideTimestamp = Date()
                    let maxOffset = max(0, self.scrollView.contentSize.height - self.scrollView.bounds.height)
                    if self.scrollView.contentOffset.y > maxOffset {
                        self.scrollView.contentOffset = CGPoint(x: 0, y: max(0, maxOffset))
                    }
                    self.scrollView.isScrollEnabled = true
                } else {
                    self.hideTimestamp = nil
                    self.scrollView.isScrollEnabled = true
                }
            }
        })
    }
}

// MARK: - UIScrollViewDelegate
extension MediatorDemoViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard scrollView === self.scrollView else { return }
        
        let panGesture = scrollView.panGestureRecognizer
        let touchLocation = panGesture.location(in: contentView)
        let outputTextViewFrame = outputTextView.frame
        
        if outputTextViewFrame.contains(touchLocation) {
            // 检查 outputTextView 是否可以滚动
            let canScrollOutput = outputTextView.contentSize.height > outputTextView.bounds.height
            let outputAtTop = outputTextView.contentOffset.y <= 0
            let translation = panGesture.translation(in: contentView)
            let velocity = panGesture.velocity(in: contentView)
            
            // 只有当 outputTextView 可以滚动，或者用户向下滑动时，才禁用外层滚动
            // 如果用户向上滑动且 outputTextView 在顶部，允许外层滚动继续
            if canScrollOutput && (translation.y > 0 || !outputAtTop) {
                scrollView.isScrollEnabled = false
                scrollViewReenableTimer?.invalidate()
                scrollViewReenableTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { [weak self] timer in
                    guard let self = self else { timer.invalidate(); return }
                    if !self.outputTextView.isDragging && !self.outputTextView.isDecelerating {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            if !self.outputTextView.isDragging && !self.outputTextView.isDecelerating {
                                self.scrollView.isScrollEnabled = true
                            }
                        }
                        timer.invalidate()
                        self.scrollViewReenableTimer = nil
                    }
                }
                return
            } else if !canScrollOutput || (outputAtTop && velocity.y < 0) {
                // outputTextView 不可滚动，或在顶部且用户向上滑动，允许外层滚动
                scrollView.isScrollEnabled = true
            }
        }
        
        scrollView.isScrollEnabled = true
        let currentOffset = scrollView.contentOffset.y
        lastScrollOffset = currentOffset
        
        if !isDescriptionVisible && !isAnimating {
            if let hideTime = hideTimestamp, Date().timeIntervalSince(hideTime) < restoreCooldown {
                return
            }
            
            let gesture = scrollView.panGestureRecognizer
            let velocity = gesture.velocity(in: scrollView)
            let translation = gesture.translation(in: scrollView)
            
            let isVerticalScroll = abs(translation.x) < abs(translation.y) || abs(translation.x) < 30
            let isUpwardVelocity = velocity.y < -50
            
            if isUpwardVelocity && isVerticalScroll {
                toggleDescription(visible: true)
            }
            else if currentOffset <= 50 && isUpwardVelocity {
                toggleDescription(visible: true)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === self.scrollView else { return }
        guard !isAnimating else { return }
        
        let offset = scrollView.contentOffset.y
        
        if offset > scrollThreshold && isDescriptionVisible {
            toggleDescription(visible: false)
        }
        
        lastScrollOffset = offset
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView === self.scrollView else { return }
        checkAndRestoreDescription(scrollView: scrollView)
        if !decelerate {
            scrollView.isScrollEnabled = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView === self.scrollView else { return }
        checkAndRestoreDescription(scrollView: scrollView)
        scrollView.isScrollEnabled = true
    }
    
    private func checkAndRestoreDescription(scrollView: UIScrollView) {
        guard !isAnimating else { return }
        guard !isDescriptionVisible else { return }
        
        if let hideTime = hideTimestamp, Date().timeIntervalSince(hideTime) < restoreCooldown {
            return
        }
        
        let offset = scrollView.contentOffset.y
        let gesture = scrollView.panGestureRecognizer
        let velocity = gesture.velocity(in: scrollView)
        
        if (offset <= 50 && velocity.y < -30) || offset <= 5 {
            toggleDescription(visible: true)
        }
    }
}
