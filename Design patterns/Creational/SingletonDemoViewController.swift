//
//  SingletonDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class SingletonDemoViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let descriptionLabel = UILabel()
    private let outputTextView = UITextView()
    private let rerunButton = UIButton(type: .system)
    
    private var descriptionHeightConstraint: NSLayoutConstraint!
    private var isDescriptionVisible = true
    private var isAnimating = false
    private var descriptionFullHeight: CGFloat = 160
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
        descriptionLabel.clipsToBounds = true
        descriptionLabel.text = """
        📋 单例模式 (Singleton)
        
        💡 定义：确保一个类只有一个实例，并提供全局访问点。
        
        🎯 用途：
        • 保证类只有一个实例（如配置管理、日志记录）
        • 提供全局访问点
        • 控制资源访问（如数据库连接池）
        
        🏗️ 实现要点：
        • 私有构造函数防止外部创建
        • 静态属性保存唯一实例
        • 提供静态方法或属性访问
        
        ⚙️ 本例：DatabaseManager 作为数据库连接管理器，全局唯一
        """
        contentView.addSubview(descriptionLabel)
        
        // 重新运行按钮
        rerunButton.setTitle("重新演示", for: .normal)
        rerunButton.backgroundColor = .systemBlue
        rerunButton.setTitleColor(.white, for: .normal)
        rerunButton.layer.cornerRadius = 8
        rerunButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        rerunButton.addTarget(self, action: #selector(rerunDemo), for: .touchUpInside)
        rerunButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rerunButton)
        
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
            
            rerunButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            rerunButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            rerunButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            rerunButton.heightAnchor.constraint(equalToConstant: 40),
            
            outputTextView.topAnchor.constraint(equalTo: rerunButton.bottomAnchor, constant: 12),
            outputTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            outputTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            outputTextView.heightAnchor.constraint(equalToConstant: 500),
            outputTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func demonstratePattern() {
        appendOutput("═══════════════════════════════════════")
        appendOutput("  单例模式演示")
        appendOutput("═══════════════════════════════════════\n")
        appendOutput("📝 测试：多次获取 DatabaseManager 实例\n")
        
        appendOutput("🔄 执行步骤：")
        appendOutput("  1️⃣ 第一次获取 DatabaseManager.shared")
        
        let db1 = DatabaseManager.shared
        appendOutput("     ✅ 实例已创建（注意：这里会打印初始化信息）")
        
        appendOutput("\n  2️⃣ 第二次获取 DatabaseManager.shared")
        let db2 = DatabaseManager.shared
        appendOutput("     ✅ 返回同一个实例（不会再次初始化）")
        
        appendOutput("\n  3️⃣ 验证两个引用指向同一对象")
        appendOutput("     db1 === db2: \(db1 === db2 ? "✅ true（是同一个对象）" : "❌ false（不同对象）")")
        
        appendOutput("\n  4️⃣ 测试连接功能（多个引用共享同一状态）")
        appendOutput("     • db1.connect() → 连接数：1")
        db1.connect()
        
        appendOutput("     • db2.connect() → 连接数：2（同一实例）")
        db2.connect()
        
        appendOutput("     • db1.connect() → 连接数：3（同一实例）")
        db1.connect()
        
        appendOutput("\n  5️⃣ 查看最终连接数")
        appendOutput("     📊 当前连接数: \(db1.getConnectionCount())")
        
        appendOutput("\n✨ 结论：无论获取多少次 DatabaseManager.shared，")
        appendOutput("      都返回同一个实例，状态在所有引用间共享。")
    }
    
    @objc private func rerunDemo() {
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
                    // 关键：即使contentSize <= bounds.height，也保持scrollEnabled=true
                    // 这样用户仍然可以向上滑动以恢复描述
                    self.scrollView.isScrollEnabled = true
                } else {
                    // 恢复描述时，清除冷却期标记
                    self.hideTimestamp = nil
                    // 恢复描述时，确保可以滚动
                    self.scrollView.isScrollEnabled = true
                }
            }
        })
    }
}

// MARK: - UIScrollViewDelegate
extension SingletonDemoViewController: UIScrollViewDelegate {
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

