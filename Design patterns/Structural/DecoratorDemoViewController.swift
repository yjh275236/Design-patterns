//
//  DecoratorDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class DecoratorDemoViewController: UIViewController {
    
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
    private var hideTimestamp: Date? // 记录描述隐藏的时间，用于冷却期
    private let restoreCooldown: TimeInterval = 0.5 // 隐藏后0.5秒内不允许恢复
    private var scrollViewReenableTimer: Timer?
    private var lastContentInsetBottom: CGFloat = 0
    
    private var output: String = "" {
        didSet {
            outputTextView.text = output
            scrollToBottom()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
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
        
        // 说明区域
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 15)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.text = """
        📋 装饰模式 (Decorator)
        
        💡 定义：动态地给一个对象添加一些额外的职责。
        
        🎯 用途：
        • 在不修改原类的情况下扩展功能
        • 组合多个功能
        • 运行时动态添加功能
        
        🏗️ 结构：
        Coffee（组件接口）
        ├── SimpleCoffee（具体组件）
        └── CoffeeDecorator（装饰器基类）
            ├── MilkDecorator（牛奶装饰器）
            ├── SugarDecorator（糖装饰器）
            └── WhipDecorator（奶油装饰器）
        
        ⚙️ 执行流程：通过装饰器链动态组合功能，运行时决定最终对象
        """
        descriptionLabel.clipsToBounds = true
        contentView.addSubview(descriptionLabel)
        
        // 按钮区域
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 12
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonStackView)
        
        let simpleButton = createButton(title: "普通咖啡", action: #selector(orderSimple))
        let milkButton = createButton(title: "加牛奶", action: #selector(orderWithMilk))
        let fullButton = createButton(title: "全加（牛奶+糖+奶油）", action: #selector(orderFull))
        
        buttonStackView.addArrangedSubview(simpleButton)
        buttonStackView.addArrangedSubview(milkButton)
        buttonStackView.addArrangedSubview(fullButton)
        
        // 清除按钮
        clearButton.setTitle("清除输出", for: .normal)
        clearButton.backgroundColor = .systemGray3
        clearButton.setTitleColor(.label, for: .normal)
        clearButton.layer.cornerRadius = 8
        clearButton.addTarget(self, action: #selector(clearOutput), for: .touchUpInside)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(clearButton)
        
        // 输出区域
        outputTextView.translatesAutoresizingMaskIntoConstraints = false
        outputTextView.isEditable = false
        outputTextView.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        outputTextView.backgroundColor = .systemGray6
        outputTextView.layer.cornerRadius = 8
        outputTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        outputTextView.isScrollEnabled = true
        contentView.addSubview(outputTextView)
        
        // 描述区域高度约束（初始为完整高度）
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
            buttonStackView.heightAnchor.constraint(equalToConstant: 140),
            
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
        appendOutput("  装饰模式演示")
        appendOutput("═══════════════════════════════════════")
        appendOutput("📝 装饰器模式允许动态添加功能")
        appendOutput("💡 通过装饰器链组合不同功能")
        appendOutput("请点击上方按钮测试不同的咖啡组合")
    }
    
    @objc private func orderSimple() {
        appendOutput("\n--- 点单：普通咖啡 ---")
        let coffee = SimpleCoffee()
        appendOutput("  咖啡：\(coffee.description())")
        appendOutput("  价格: ¥\(coffee.cost())")
        appendOutput("✅ 订单完成")
    }
    
    @objc private func orderWithMilk() {
        appendOutput("\n--- 点单：咖啡加牛奶 ---")
        var coffee: Coffee = SimpleCoffee()
        coffee = MilkDecorator(coffee: coffee)
        appendOutput("  咖啡：\(coffee.description())")
        appendOutput("  价格: ¥\(coffee.cost())")
        appendOutput("✅ 订单完成")
    }
    
    @objc private func orderFull() {
        appendOutput("\n--- 点单：全加咖啡 ---")
        appendOutput("  步骤1: 创建基础咖啡")
        var coffee: Coffee = SimpleCoffee()
        appendOutput("  步骤2: 添加牛奶装饰器")
        coffee = MilkDecorator(coffee: coffee)
        appendOutput("  步骤3: 添加糖装饰器")
        coffee = SugarDecorator(coffee: coffee)
        appendOutput("  步骤4: 添加奶油装饰器")
        coffee = WhipDecorator(coffee: coffee)
        appendOutput("  最终：\(coffee.description())")
        appendOutput("  价格: ¥\(coffee.cost())")
        appendOutput("✅ 订单完成")
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
        // 防止重复触发
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
                    // 记录隐藏时间，启动冷却期
                    self.hideTimestamp = Date()
                    
                    // 隐藏描述后，调整offset
                    let maxOffset = max(0, self.scrollView.contentSize.height - self.scrollView.bounds.height)
                    if self.scrollView.contentOffset.y > maxOffset {
                        self.scrollView.contentOffset = CGPoint(x: 0, y: max(0, maxOffset))
                    }
                    self.scrollView.isScrollEnabled = true
                } else {
                    // 恢复描述时，清除冷却期标记
                    self.hideTimestamp = nil
                    self.scrollView.isScrollEnabled = true
                }
            }
        })
    }
}

// MARK: - UIScrollViewDelegate
extension DecoratorDemoViewController: UIScrollViewDelegate {
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
        
        // 检测向上滑动意图，立即恢复描述
        if !isDescriptionVisible && !isAnimating {
            // 检查冷却期：如果刚隐藏不久，不立即恢复
            if let hideTime = hideTimestamp, Date().timeIntervalSince(hideTime) < restoreCooldown {
                return
            }
            
            let gesture = scrollView.panGestureRecognizer
            let velocity = gesture.velocity(in: scrollView)
            let translation = gesture.translation(in: scrollView)
            
            // 检测明显的向上滑动意图：
            // 1. y方向速度 < -50（向上滑动，降低阈值）
            // 2. 主要是垂直滑动（不是水平滑动）
            let isVerticalScroll = abs(translation.x) < abs(translation.y) || abs(translation.x) < 30
            let isUpwardVelocity = velocity.y < -50
            
            // 条件1: 有明显的向上速度且是垂直滑动
            if isUpwardVelocity && isVerticalScroll {
                toggleDescription(visible: true)
            }
            // 条件2: 如果已经在接近顶部（<= 50px），也恢复（放宽范围）
            else if currentOffset <= 50 && isUpwardVelocity {
                toggleDescription(visible: true)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === self.scrollView else { return }
        guard !isAnimating else { return }
        
        let offset = scrollView.contentOffset.y
        
        // 向下滑动超过阈值时，隐藏描述
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
        // 拖拽或滚动结束时检查状态
        guard !isAnimating else { return }
        
        guard !isDescriptionVisible else { return }
        
        // 检查冷却期
        if let hideTime = hideTimestamp, Date().timeIntervalSince(hideTime) < restoreCooldown {
            return
        }
        
        let offset = scrollView.contentOffset.y
        let gesture = scrollView.panGestureRecognizer
        let velocity = gesture.velocity(in: scrollView)
        
        // 恢复条件（放宽）：
        // 1. 接近顶部（<= 50px）
        // 2. 且有向上滑动速度（velocity.y < -30，降低阈值）或offset很小（<= 5px）
        if (offset <= 50 && velocity.y < -30) || offset <= 5 {
            toggleDescription(visible: true)
        }
    }
}
