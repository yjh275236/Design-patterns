//
//  PrototypePattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 原型模式

protocol Cloneable {
    func clone() -> Self
}

class PrototypeShape: Cloneable {
    var x: Int
    var y: Int
    var color: String
    
    init(x: Int = 0, y: Int = 0, color: String = "黑色") {
        self.x = x
        self.y = y
        self.color = color
    }
    
    func clone() -> Self {
        return PrototypeShape(x: self.x, y: self.y, color: self.color) as! Self
    }
    
    func describe() -> String {
        return "形状在位置(\(x), \(y))，颜色: \(color)"
    }
}

class PrototypeCircle: PrototypeShape {
    var radius: Double
    
    init(x: Int = 0, y: Int = 0, color: String = "黑色", radius: Double = 1.0) {
        self.radius = radius
        super.init(x: x, y: y, color: color)
    }
    
    override func clone() -> Self {
        return PrototypeCircle(x: self.x, y: self.y, color: self.color, radius: self.radius) as! Self
    }
    
    override func describe() -> String {
        return "圆形在位置(\(x), \(y))，颜色: \(color)，半径: \(radius)"
    }
}

class PrototypeRectangle: PrototypeShape {
    var width: Double
    var height: Double
    
    init(x: Int = 0, y: Int = 0, color: String = "黑色", width: Double = 1.0, height: Double = 1.0) {
        self.width = width
        self.height = height
        super.init(x: x, y: y, color: color)
    }
    
    override func clone() -> Self {
        return PrototypeRectangle(x: self.x, y: self.y, color: self.color, width: self.width, height: self.height) as! Self
    }
    
    override func describe() -> String {
        return "矩形在位置(\(x), \(y))，颜色: \(color)，尺寸: \(width) × \(height)"
    }
}

