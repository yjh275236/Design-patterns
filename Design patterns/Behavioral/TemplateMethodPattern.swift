//
//  TemplateMethodPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 模板方法模式

class Game {
    func play() -> String {
        var result = ""
        result += initialize() + "\n"
        result += startPlay() + "\n"
        result += endPlay() + "\n"
        return result
    }
    
    func initialize() -> String {
        return "游戏初始化"
    }
    
    func startPlay() -> String {
        return "开始游戏"
    }
    
    func endPlay() -> String {
        return "结束游戏"
    }
}

class Cricket: Game {
    override func initialize() -> String {
        return "板球游戏初始化。准备球和球棒。"
    }
    
    override func startPlay() -> String {
        return "板球游戏开始。享受游戏！"
    }
    
    override func endPlay() -> String {
        return "板球游戏结束。"
    }
}

class Football: Game {
    override func initialize() -> String {
        return "足球游戏初始化。准备足球。"
    }
    
    override func startPlay() -> String {
        return "足球游戏开始。享受游戏！"
    }
    
    override func endPlay() -> String {
        return "足球游戏结束。"
    }
}

