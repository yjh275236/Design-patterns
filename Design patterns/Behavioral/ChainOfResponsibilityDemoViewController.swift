//
//  ChainOfResponsibilityDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class ChainOfResponsibilityDemoViewController: UIViewController {
    
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
    private let scrollThreshold: CGFloat = 100 // 提高阈值，避免频繁触发
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
        📋 责任链模式 (Chain of Responsibility)
        
        💡 定义：将请求沿着处理者链传递，直到有处理者处理它。
        
        🎯 用途：
        • 避免请求发送者和接收者耦合
        • 动态组合处理链
        • 多个对象都有机会处理请求
        
        🏗️ 结构：
        Handler（处理者接口）
        ├── Cashier（收银员，处理 ≤¥100）
        ├── Manager（经理，处理 ≤¥1000 和退款）
        └── Director（总监，处理所有其他请求）
        
        ⚙️ 执行流程：请求从链首开始，依次传递直到被处理
        """
        descriptionLabel.clipsToBounds = true
        contentView.addSubview(descriptionLabel)
        
        // 按钮区域
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 12
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonStackView)
        
        let smallButton = createButton(title: "小金额购买 (¥50)", action: #selector(handleSmallPurchase))
        let mediumButton = createButton(title: "中金额购买 (¥500)", action: #selector(handleMediumPurchase))
        let refundButton = createButton(title: "退款请求 (¥200)", action: #selector(handleRefund))
        
        buttonStackView.addArrangedSubview(smallButton)
        buttonStackView.addArrangedSubview(mediumButton)
        buttonStackView.addArrangedSubview(refundButton)
        
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
        // 需要先设置宽度才能计算正确高度
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
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setupChain() -> Handler {
        let cashier = Cashier()
        let manager = Manager()
        let director = Director()
        
        cashier.next = manager
        manager.next = director
        
        return cashier
    }
    
    private func demonstratePattern() {
        appendOutput("═══════════════════════════════════════")
        appendOutput("  责任链模式演示")
        appendOutput("═══════════════════════════════════════\n")
        appendOutput("📝 处理链已创建：")
        appendOutput("  收银员 → 经理 → 总监")
        appendOutput("\n💡 处理规则：")
        appendOutput("  • 收银员：处理 ≤¥100 的购买")
        appendOutput("  • 经理：处理 ≤¥1000 的购买和所有退款")
        appendOutput("  • 总监：处理所有其他请求")
        appendOutput("\n请点击上方按钮测试不同的请求类型\n")
    }
    
    @objc private func handleSmallPurchase() {
        appendOutput("\n" + String(repeating: "─", count: 40))
        appendOutput("🛒 测试：小金额购买请求")
        appendOutput(String(repeating: "─", count: 40))
        
        let chain = setupChain()
        let request = Request(type: .purchase, amount: 50, description: "购买商品A")
        
        appendOutput("\n📨 请求信息：")
        appendOutput("  类型：购买")
        appendOutput("  金额：¥50")
        appendOutput("  描述：购买商品A")
        
        appendOutput("\n🔄 处理流程：")
        appendOutput("  1️⃣ 请求发送给收银员...")
        
        if let result = chain.handle(request: request) {
            appendOutput("  ✅ \(result)")
            appendOutput("\n✨ 处理完成！请求在收银员处被处理")
        }
    }
    
    @objc private func handleMediumPurchase() {
        appendOutput("\n" + String(repeating: "─", count: 40))
        appendOutput("🛒 测试：中金额购买请求")
        appendOutput(String(repeating: "─", count: 40))
        
        let chain = setupChain()
        let request = Request(type: .purchase, amount: 500, description: "购买商品B")
        
        appendOutput("\n📨 请求信息：")
        appendOutput("  类型：购买")
        appendOutput("  金额：¥500")
        appendOutput("  描述：购买商品B")
        
        appendOutput("\n🔄 处理流程：")
        appendOutput("  1️⃣ 请求发送给收银员（金额超限，传递）...")
        appendOutput("  2️⃣ 请求传递给经理...")
        
        if let result = chain.handle(request: request) {
            appendOutput("  ✅ \(result)")
            appendOutput("\n✨ 处理完成！请求在经理处被处理")
        }
    }
    
    @objc private func handleRefund() {
        appendOutput("\n" + String(repeating: "─", count: 40))
        appendOutput("💰 测试：退款请求")
        appendOutput(String(repeating: "─", count: 40))
        
        let chain = setupChain()
        let request = Request(type: .refund, amount: 200, description: "退款申请")
        
        appendOutput("\n📨 请求信息：")
        appendOutput("  类型：退款")
        appendOutput("  金额：¥200")
        appendOutput("  描述：退款申请")
        
        appendOutput("\n🔄 处理流程：")
        appendOutput("  1️⃣ 请求发送给收银员（无权限，传递）...")
        appendOutput("  2️⃣ 请求传递给经理...")
        
        if let result = chain.handle(request: request) {
            appendOutput("  ✅ \(result)")
            appendOutput("\n✨ 处理完成！请求在经理处被处理")
        }
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
        guard !isAnimating && isDescriptionVisible != visible else {
            print("🔍 toggleDescription: 跳过 - isAnimating=\(isAnimating), isVisible=\(isDescriptionVisible), target=\(visible)")
            return
        }
        
        print("🔄 toggleDescription: \(visible ? "显示" : "隐藏") 描述")
        print("   当前offset: \(scrollView.contentOffset.y)")
        print("   contentSize: \(scrollView.contentSize.height)")
        print("   bounds.height: \(scrollView.bounds.height)")
        
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
            print("✅ toggleDescription: 动画完成")
            print("   完成后 - offset: \(self.scrollView.contentOffset.y), contentSize: \(self.scrollView.contentSize.height), bounds: \(self.scrollView.bounds.height)")
            
            DispatchQueue.main.async {
                // 等待布局更新完成
                self.view.layoutIfNeeded()
                
                if !visible {
                    // 记录隐藏时间，启动冷却期
                    self.hideTimestamp = Date()
                    
                    // 隐藏描述后，调整offset
                    let maxOffset = max(0, self.scrollView.contentSize.height - self.scrollView.bounds.height)
                    let currentOffset = self.scrollView.contentOffset.y
                    print("   隐藏后检查: maxOffset=\(maxOffset), currentOffset=\(currentOffset), contentSize=\(self.scrollView.contentSize.height), bounds=\(self.scrollView.bounds.height)")
                    
                    if currentOffset > maxOffset {
                        print("   调整offset从 \(currentOffset) 到 \(max(0, maxOffset))")
                        self.scrollView.contentOffset = CGPoint(x: 0, y: max(0, maxOffset))
                    }
                    
                    // 关键：即使contentSize <= bounds.height，也保持scrollEnabled=true
                    // 这样用户仍然可以向上滑动以恢复描述
                    self.scrollView.isScrollEnabled = true
                    print("   隐藏完成 - scrollEnabled始终为true，启动冷却期")
                } else {
                    // 恢复描述时，清除冷却期标记
                    self.hideTimestamp = nil
                    // 恢复描述时，确保可以滚动
                    self.scrollView.isScrollEnabled = true
                    print("   恢复描述完成，scrollEnabled: true，清除冷却期")
                }
            }
        })
    }
}

// MARK: - UIScrollViewDelegate
extension ChainOfResponsibilityDemoViewController: UIScrollViewDelegate {
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
            // 检查冷却期：如果刚隐藏不久，不立即恢复
            if let hideTime = hideTimestamp, Date().timeIntervalSince(hideTime) < restoreCooldown {
                print("⏳ scrollViewWillBeginDragging: 冷却期中，跳过恢复（距离隐藏: \(Date().timeIntervalSince(hideTime))秒）")
                return
            }
            
            let gesture = scrollView.panGestureRecognizer
            let velocity = gesture.velocity(in: scrollView)
            let translation = gesture.translation(in: scrollView)
            
            print("   velocity: y=\(velocity.y), x=\(velocity.x)")
            print("   translation: y=\(translation.y), x=\(translation.x)")
            
            // 检测明显的向上滑动意图：
            // 1. y方向速度 < -50（向上滑动，降低阈值）
            // 2. 主要是垂直滑动（不是水平滑动）
            let isVerticalScroll = abs(translation.x) < abs(translation.y) || abs(translation.x) < 30
            let isUpwardVelocity = velocity.y < -50
            
            // 条件1: 有明显的向上速度且是垂直滑动
            if isUpwardVelocity && isVerticalScroll {
                print("🔼 scrollViewWillBeginDragging: 检测到明显的向上滑动意图(velocity=\(velocity.y), translation=\(translation.y), 垂直=\(isVerticalScroll))，立即恢复描述")
                toggleDescription(visible: true)
            }
            // 条件2: 如果已经在接近顶部（<= 50px），也恢复（放宽范围）
            else if currentOffset <= 50 && isUpwardVelocity {
                print("🔼 scrollViewWillBeginDragging: 接近顶部(offset=\(currentOffset))且向上滑动，恢复描述")
                toggleDescription(visible: true)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === self.scrollView else { return }
        guard !isAnimating else { return }
        
        let offset = scrollView.contentOffset.y
        let isScrollingUp = offset < lastScrollOffset
        
        print("📜 scrollViewDidScroll: offset=\(offset), last=\(lastScrollOffset), 向上=\(isScrollingUp), descVisible=\(isDescriptionVisible)")
        
        // 向下滑动超过阈值时，隐藏描述
        if offset > scrollThreshold && isDescriptionVisible {
            print("🔽 触发隐藏：向下滑动且offset>\(scrollThreshold)")
            toggleDescription(visible: false)
        }
        // scrollViewDidScroll中不再检查恢复，只在scrollViewWillBeginDragging和结束时检查
        // 这样可以避免向下滑动时的微小波动导致误恢复
        
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
        guard !isAnimating else {
            print("⏸️ checkAndRestoreDescription: 跳过（动画中）")
            return
        }
        
        guard !isDescriptionVisible else { return }
        
        // 检查冷却期（更严格）
        if let hideTime = hideTimestamp, Date().timeIntervalSince(hideTime) < restoreCooldown {
            print("⏳ checkAndRestoreDescription: 冷却期中，跳过恢复（距离隐藏: \(String(format: "%.2f", Date().timeIntervalSince(hideTime)))秒）")
            return
        }
        
        let offset = scrollView.contentOffset.y
        let gesture = scrollView.panGestureRecognizer
        let velocity = gesture.velocity(in: scrollView)
        
        print("🔍 checkAndRestoreDescription: offset=\(offset), velocity=\(velocity.y), descVisible=\(isDescriptionVisible)")
        
        // 恢复条件（放宽）：
        // 1. 接近顶部（<= 50px）
        // 2. 且有向上滑动速度（velocity.y < -30，降低阈值）或offset很小（<= 5px）
        if (offset <= 50 && velocity.y < -30) || offset <= 5 {
            print("✅ checkAndRestoreDescription: 触发恢复（offset=\(offset) <= 50 且 velocity=\(velocity.y) < -30，或offset <= 5）")
            toggleDescription(visible: true)
        } else {
            print("❌ checkAndRestoreDescription: 条件不满足（offset=\(offset), velocity=\(velocity.y)）")
        }
    }
}

