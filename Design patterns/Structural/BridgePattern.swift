//
//  BridgePattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 桥接模式

// 颜色协议，定义应用颜色的方法
protocol Color {
    // 应用颜色并返回颜色名称
    func applyColor() -> String
}

// 红色类，实现Color协议
class Red: Color {
    // 实现applyColor方法，返回红色
    func applyColor() -> String {
        // 返回红色字符串
        return "红色"
    }
}

// 蓝色类，实现Color协议
class Blue: Color {
    // 实现applyColor方法，返回蓝色
    func applyColor() -> String {
        // 返回蓝色字符串
        return "蓝色"
    }
}

// 绿色类，实现Color协议
class Green: Color {
    // 实现applyColor方法，返回绿色
    func applyColor() -> String {
        // 返回绿色字符串
        return "绿色"
    }
}

// 形状协议，定义形状的接口，包含颜色属性
protocol Shape {
    // 颜色属性，可读写
    var color: Color { get set }
    // 绘制形状的方法
    func draw() -> String
}

// 圆形类，实现Shape协议
class BridgeCircle: Shape {
    // 颜色属性，符合Shape协议要求
    var color: Color
    
    // 初始化方法，接收颜色参数
    init(color: Color) {
        // 设置颜色属性
        self.color = color
    }
    
    // 实现draw方法，绘制圆形
    func draw() -> String {
        // 返回绘制圆形的描述，使用颜色
        return "绘制\(color.applyColor())的圆形"
    }
}

// 正方形类，实现Shape协议
class BridgeSquare: Shape {
    // 颜色属性，符合Shape协议要求
    var color: Color
    
    // 初始化方法，接收颜色参数
    init(color: Color) {
        // 设置颜色属性
        self.color = color
    }
    
    // 实现draw方法，绘制正方形
    func draw() -> String {
        // 返回绘制正方形的描述，使用颜色
        return "绘制\(color.applyColor())的正方形"
    }
}

