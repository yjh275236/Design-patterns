//
//  BridgePattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 桥接模式

protocol Color {
    func applyColor() -> String
}

class Red: Color {
    func applyColor() -> String {
        return "红色"
    }
}

class Blue: Color {
    func applyColor() -> String {
        return "蓝色"
    }
}

class Green: Color {
    func applyColor() -> String {
        return "绿色"
    }
}

protocol Shape {
    var color: Color { get set }
    func draw() -> String
}

class BridgeCircle: Shape {
    var color: Color
    
    init(color: Color) {
        self.color = color
    }
    
    func draw() -> String {
        return "绘制\(color.applyColor())的圆形"
    }
}

class BridgeSquare: Shape {
    var color: Color
    
    init(color: Color) {
        self.color = color
    }
    
    func draw() -> String {
        return "绘制\(color.applyColor())的正方形"
    }
}

