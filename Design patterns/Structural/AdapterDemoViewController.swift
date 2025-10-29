//
//  AdapterDemoViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class AdapterDemoViewController: UIViewController {
    
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
        
        let mp3Button = createButton(title: "播放 MP3", action: #selector(playMP3))
        let vlcButton = createButton(title: "播放 VLC", action: #selector(playVLC))
        let mp4Button = createButton(title: "播放 MP4", action: #selector(playMP4))
        
        buttonStackView.addArrangedSubview(mp3Button)
        buttonStackView.addArrangedSubview(vlcButton)
        buttonStackView.addArrangedSubview(mp4Button)
        
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
    
    private func demonstratePattern() {
        appendOutput("=== 适配器模式演示 ===\n")
        appendOutput("通过适配器播放不同格式的音频\n")
    }
    
    @objc private func playMP3() {
        appendOutput("\n--- 播放 MP3 ---")
        let player = EnhancedAudioPlayer()
        player.play(audioType: "mp3", fileName: "song.mp3")
    }
    
    @objc private func playVLC() {
        appendOutput("\n--- 播放 VLC ---")
        let player = EnhancedAudioPlayer()
        player.play(audioType: "vlc", fileName: "movie.vlc")
    }
    
    @objc private func playMP4() {
        appendOutput("\n--- 播放 MP4 ---")
        let player = EnhancedAudioPlayer()
        player.play(audioType: "mp4", fileName: "video.mp4")
    }
    
    private func appendOutput(_ text: String) {
        output += text + "\n"
    }
}

