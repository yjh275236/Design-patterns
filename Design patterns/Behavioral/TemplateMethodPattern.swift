//
//  TemplateMethodPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 模板方法模式
// 核心角色：Game 基类定义算法骨架（play），子类重写步骤细节
// 新手提示：关注“核心实现”标注，理解模板方法如何固定流程、允许步骤变化

// 游戏基类，定义游戏流程的模板方法
class Game {
    // 模板方法：定义游戏的标准流程
    func play() -> String {
        // 初始化结果字符串
        var result = ""
        // 第一步：初始化游戏
        result += initialize() + "\n"
        // 第二步：开始游戏
        result += startPlay() + "\n"
        // 第三步：结束游戏
        result += endPlay() + "\n"
        // 返回完整的游戏流程结果
        return result
    }
    
    // 核心实现：具体步骤允许子类覆盖
    func initialize() -> String {
        // 默认实现：返回基础初始化信息
        return "游戏初始化"
    }
    
    // 开始游戏方法，由子类重写
    func startPlay() -> String {
        // 默认实现：返回基础开始信息
        return "开始游戏"
    }
    
    // 结束游戏方法，由子类重写
    func endPlay() -> String {
        // 默认实现：返回基础结束信息
        return "结束游戏"
    }
}

// 板球游戏类，继承自Game，重写模板方法中的步骤
class Cricket: Game {
    // 重写initialize方法，提供板球游戏特定的初始化
    override func initialize() -> String {
        // 返回板球游戏特定的初始化信息
        return "板球游戏初始化。准备球和球棒。"
    }
    
    // 重写startPlay方法，提供板球游戏特定的开始信息
    override func startPlay() -> String {
        // 返回板球游戏特定的开始信息
        return "板球游戏开始。享受游戏！"
    }
    
    // 重写endPlay方法，提供板球游戏特定的结束信息
    override func endPlay() -> String {
        // 返回板球游戏特定的结束信息
        return "板球游戏结束。"
    }
}

// 足球游戏类，继承自Game，重写模板方法中的步骤
class Football: Game {
    // 重写initialize方法，提供足球游戏特定的初始化
    override func initialize() -> String {
        // 返回足球游戏特定的初始化信息
        return "足球游戏初始化。准备足球。"
    }
    
    // 重写startPlay方法，提供足球游戏特定的开始信息
    override func startPlay() -> String {
        // 返回足球游戏特定的开始信息
        return "足球游戏开始。享受游戏！"
    }
    
    // 重写endPlay方法，提供足球游戏特定的结束信息
    override func endPlay() -> String {
        // 返回足球游戏特定的结束信息
        return "足球游戏结束。"
    }
}

// 使用示例（运行模板方法，体验固定流程与可变步骤）：
// let cricket = Cricket()
// print(cricket.play())               // 核心：调用模板方法 play()
// let football = Football()
// print(football.play())

