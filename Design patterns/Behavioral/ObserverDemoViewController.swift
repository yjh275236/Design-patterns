//
//  ObserverDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class ObserverDemoViewController: UIViewController {
    
    private let outputTextView = UITextView()
    private let buttonStackView = UIStackView()
    
    private var output: String = "" {
        didSet {
            outputTextView.text = output
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
    
    private func setupUI() {
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 10
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)
        
        let updateButton = createButton(title: "更新天气数据", action: #selector(updateWeather))
        
        buttonStackView.addArrangedSubview(updateButton)
        
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
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            
            outputTextView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20),
            outputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            outputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            outputTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
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
        appendOutput("=== 观察者模式演示 ===\n")
        appendOutput("天气数据变化时，观察者自动收到通知\n")
    }
    
    private var updateCount = 0
    
    @objc private func updateWeather() {
        updateCount += 1
        let temp = Double.random(in: 15...30)
        let humidity = Double.random(in: 40...80)
        let pressure = Double.random(in: 980...1020)
        
        appendOutput("\n--- 更新天气数据 \(updateCount) ---")
        appendOutput("新数据: 温度=\(String(format: "%.1f", temp))°C, 湿度=\(String(format: "%.1f", humidity))%, 气压=\(String(format: "%.1f", pressure))hPa")
        
        weatherData.setMeasurements(temperature: temp, humidity: humidity, pressure: pressure)
        
        appendOutput("\n观察者已收到通知并更新显示")
    }
    
    private func appendOutput(_ text: String) {
        output += text + "\n"
    }
}

