//
//  ObserverDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class ObserverDemoViewController: UIViewController {
    
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
    
    private let weatherData = WeatherData()
    private let currentDisplay = CurrentConditionsDisplay()
    private let statisticsDisplay = StatisticsDisplay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupObservers()
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
        📋 观察者模式 (Observer)
        
        💡 定义：定义对象间一对多的依赖关系，当一个对象的状态发生改变时，所有依赖于它的对象都得到通知。
        
        🎯 用途：
        • 解耦观察者和被观察者
        • 支持广播通信
        • 动态添加或删除观察者
        
        🏗️ 结构：
        WeatherData（主题，被观察者）
        ├── CurrentConditionsDisplay（观察者1）
        └── StatisticsDisplay（观察者2）
        
        ⚙️ 执行流程：主题状态改变时，自动通知所有观察者更新
        """
        descriptionLabel.clipsToBounds = true
        contentView.addSubview(descriptionLabel)
        
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 12
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonStackView)
        
        let updateButton = createButton(title: "更新天气数据", action: #selector(updateWeather))
        
        buttonStackView.addArrangedSubview(updateButton)
        
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
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            
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
    
    private func setupObservers() {
        weatherData.registerObserver(currentDisplay)
        weatherData.registerObserver(statisticsDisplay)
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
        appendOutput("  观察者模式演示")
        appendOutput("═══════════════════════════════════════")
        appendOutput("📝 观察者模式实现一对多的依赖关系")
        appendOutput("💡 主题状态改变时，观察者自动收到通知")
        appendOutput("请点击上方按钮更新天气数据，观察者将自动更新")
    }
    
    private var updateCount = 0
    
    @objc private func updateWeather() {
        updateCount += 1
        appendOutput("\n--- 更新天气数据 \(updateCount) ---")
        appendOutput("  步骤1: 生成新的天气数据")
        let temp = Double.random(in: 15...30)
        let humidity = Double.random(in: 40...80)
        let pressure = Double.random(in: 980...1020)
        
        appendOutput("  新数据: 温度=\(String(format: "%.1f", temp))°C, 湿度=\(String(format: "%.1f", humidity))%, 气压=\(String(format: "%.1f", pressure))hPa")
        appendOutput("  步骤2: 设置新数据（触发通知）")
        weatherData.setMeasurements(temperature: temp, humidity: humidity, pressure: pressure)
        
        appendOutput("  步骤3: 所有观察者已收到通知并更新显示")
        appendOutput("✅ 观察者模式：自动通知机制工作正常")
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
extension ObserverDemoViewController: UIScrollViewDelegate {
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
