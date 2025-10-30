//
//  FactoryMethodDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class FactoryMethodDemoViewController: UIViewController {
    
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
    private var scrollViewReenableTimer: Timer? // 用于重新启用外层scrollView的定时器
    private var lastContentInsetBottom: CGFloat = 0 // 记录上次设置的contentInset.bottom值，避免频繁变化
    
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
        // 确保outputTextView始终可以滚动
        outputTextView.textContainer.heightTracksTextView = false
        
        // 避免在滚动过程中频繁调整contentInset，这会导致回弹
        // 只在outputTextView不在滚动时才调整
        guard !outputTextView.isDragging && !outputTextView.isDecelerating else {
            return
        }
        
        // 确保即使内容很少也能有滚动效果
        // 只在contentSize变化时调整contentInset，避免频繁变化导致回弹
        if outputTextView.contentSize.height <= outputTextView.bounds.height {
            let extraHeight = max(1, outputTextView.bounds.height - outputTextView.contentSize.height + 1)
            // 只有当值真的改变时才更新，避免频繁变化
            if abs(extraHeight - lastContentInsetBottom) > 0.5 {
                outputTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: extraHeight, right: 0)
                lastContentInsetBottom = extraHeight
            }
        } else {
            // 内容充足时，重置contentInset
            if lastContentInsetBottom > 0 {
                outputTextView.contentInset = .zero
                lastContentInsetBottom = 0
            }
        }
    }
    
    deinit {
        // 清理定时器
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
        📋 工厂方法模式 (Factory Method)
        
        💡 定义：定义一个创建对象的接口，让子类决定实例化哪一个类。
        
        🎯 用途：
        • 将对象创建和使用分离
        • 让子类决定创建哪种对象
        • 支持开闭原则（对扩展开放，对修改关闭）
        
        🏗️ 结构：
        Logistics（抽象工厂接口）
        ├── RoadLogistics（陆路物流，创建Truck）
        ├── SeaLogistics（海运物流，创建Ship）
        └── AirLogistics（空运物流，创建Airplane）
        
        ⚙️ 执行流程：客户端通过工厂方法创建具体产品，而不知道具体实现
        """
        descriptionLabel.clipsToBounds = true
        contentView.addSubview(descriptionLabel)
        
        // 按钮区域
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 12
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonStackView)
        
        let roadButton = createButton(title: "🚚 陆路运输", action: #selector(roadDelivery))
        let seaButton = createButton(title: "🚢 海运", action: #selector(seaDelivery))
        let airButton = createButton(title: "✈️ 空运", action: #selector(airDelivery))
        
        buttonStackView.addArrangedSubview(roadButton)
        buttonStackView.addArrangedSubview(seaButton)
        buttonStackView.addArrangedSubview(airButton)
        
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
        // 确保输出视图始终可以滚动
        outputTextView.isScrollEnabled = true
        // 不设置alwaysBounceVertical，避免不必要的弹性效果导致回弹
        // 通过contentInset来确保可以滚动即可
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
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func demonstratePattern() {
        appendOutput("═══════════════════════════════════════")
        appendOutput("  工厂方法模式演示")
        appendOutput("═══════════════════════════════════════\n")
        appendOutput("📝 可用运输方式：")
        appendOutput("  🚚 陆路运输 - 使用卡车运输")
        appendOutput("  🚢 海运 - 使用船只运输")
        appendOutput("  ✈️ 空运 - 使用飞机运输")
        appendOutput("\n💡 每种方式都由对应的工厂类创建运输工具")
        appendOutput("请点击上方按钮测试不同的运输方式\n")
    }
    
    @objc private func roadDelivery() {
        appendOutput("\n" + String(repeating: "─", count: 40))
        appendOutput("🚚 测试：陆路运输")
        appendOutput(String(repeating: "─", count: 40))
        
        appendOutput("\n📦 执行流程：")
        appendOutput("  1️⃣ 创建 RoadLogistics 工厂...")
        
        let logistics = RoadLogistics()
        
        appendOutput("  2️⃣ 工厂创建 Truck 对象...")
        appendOutput("  3️⃣ 调用 planDelivery() 方法...")
        
        logistics.planDelivery()
        
        appendOutput("  ✅ 用卡车运输货物")
        appendOutput("\n✨ 运输完成！客户无需知道具体使用的是Truck类")
    }
    
    @objc private func seaDelivery() {
        appendOutput("\n" + String(repeating: "─", count: 40))
        appendOutput("🚢 测试：海运")
        appendOutput(String(repeating: "─", count: 40))
        
        appendOutput("\n📦 执行流程：")
        appendOutput("  1️⃣ 创建 SeaLogistics 工厂...")
        
        let logistics = SeaLogistics()
        
        appendOutput("  2️⃣ 工厂创建 Ship 对象...")
        appendOutput("  3️⃣ 调用 planDelivery() 方法...")
        
        logistics.planDelivery()
        
        appendOutput("  ✅ 用船运输货物")
        appendOutput("\n✨ 运输完成！客户无需知道具体使用的是Ship类")
    }
    
    @objc private func airDelivery() {
        appendOutput("\n" + String(repeating: "─", count: 40))
        appendOutput("✈️ 测试：空运")
        appendOutput(String(repeating: "─", count: 40))
        
        appendOutput("\n📦 执行流程：")
        appendOutput("  1️⃣ 创建 AirLogistics 工厂...")
        
        let logistics = AirLogistics()
        
        appendOutput("  2️⃣ 工厂创建 Airplane 对象...")
        appendOutput("  3️⃣ 调用 planDelivery() 方法...")
        
        logistics.planDelivery()
        
        appendOutput("  ✅ 用飞机运输货物")
        appendOutput("\n✨ 运输完成！客户无需知道具体使用的是Airplane类")
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
extension FactoryMethodDemoViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 只处理外层scrollView的滚动事件
        guard scrollView === self.scrollView else { return }
        
        // 检查触摸位置是否在outputTextView内
        let panGesture = scrollView.panGestureRecognizer
        let touchLocation = panGesture.location(in: contentView)
        let outputTextViewFrame = outputTextView.frame
        
        // 如果触摸在outputTextView内，则禁用外层scrollView的滚动，让outputTextView处理滚动
        if outputTextViewFrame.contains(touchLocation) {
            // 检查 outputTextView 是否可以滚动
            let canScrollOutput = outputTextView.contentSize.height > outputTextView.bounds.height
            let outputAtTop = outputTextView.contentOffset.y <= 0
            let translation = panGesture.translation(in: contentView)
            let velocity = panGesture.velocity(in: contentView)
            
            // 只有当 outputTextView 可以滚动，或者用户向下滑动时，才禁用外层滚动
            // 如果用户向上滑动且 outputTextView 在顶部，允许外层滚动继续
            if canScrollOutput && (translation.y > 0 || !outputAtTop) {
                // 禁用外层scrollView的滚动，让outputTextView处理滚动
                scrollView.isScrollEnabled = false
                
                // 取消之前的定时器
                scrollViewReenableTimer?.invalidate()
                
                // 设置定时器，定期检查outputTextView的滚动状态
                // 如果outputTextView不在滚动，则重新启用外层scrollView
                // 使用较长的检查间隔，避免频繁检查和回弹
                scrollViewReenableTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { [weak self] timer in
                    guard let self = self else {
                        timer.invalidate()
                        return
                    }
                    // 检查outputTextView是否还在滚动
                    let isStillScrolling = self.outputTextView.isDragging || self.outputTextView.isDecelerating
                    if !isStillScrolling {
                        // outputTextView不再滚动，延迟一点时间后再重新启用外层scrollView
                        // 这样可以避免立即切换导致的冲突和回弹
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            // 再次确认outputTextView不在滚动
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
        
        // 不在outputTextView内，取消定时器
        scrollViewReenableTimer?.invalidate()
        scrollViewReenableTimer = nil
        
        // 确保scrollView是启用的
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
        // 只处理外层scrollView的滚动事件
        guard scrollView === self.scrollView else { return }
        
        // 防止在动画过程中触发
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
        // 只处理外层scrollView的滚动事件
        guard scrollView === self.scrollView else { return }
        checkAndRestoreDescription(scrollView: scrollView)
        // 如果没有减速，立即重新启用滚动
        if !decelerate {
            scrollView.isScrollEnabled = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 只处理外层scrollView的滚动事件
        guard scrollView === self.scrollView else { return }
        checkAndRestoreDescription(scrollView: scrollView)
        // 滚动完全结束后，重新启用
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


