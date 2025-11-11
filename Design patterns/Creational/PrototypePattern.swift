//
//  PrototypePattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 原型模式

// 可克隆协议，定义克隆方法
protocol Cloneable {
    // 克隆方法，返回自身类型的副本
    func clone() -> Self
}

// 原型形状类，实现Cloneable协议
class PrototypeShape: Cloneable {
    // x坐标
    var x: Int
    // y坐标
    var y: Int
    // 颜色
    var color: String
    
    // 初始化方法，提供默认值
    init(x: Int = 0, y: Int = 0, color: String = "黑色") {
        // 设置x坐标
        self.x = x
        // 设置y坐标
        self.y = y
        // 设置颜色
        self.color = color
    }
    
    // 实现clone方法，创建当前对象的副本
    func clone() -> Self {
        // 创建新的PrototypeShape实例，复制所有属性值
        return PrototypeShape(x: self.x, y: self.y, color: self.color) as! Self
    }
    
    // 返回形状的描述信息
    func describe() -> String {
        // 返回包含位置和颜色的描述字符串
        return "形状在位置(\(x), \(y))，颜色: \(color)"
    }
}

// 原型圆形类，继承自PrototypeShape
class PrototypeCircle: PrototypeShape {
    // 半径属性
    var radius: Double
    
    // 初始化方法，包含圆形特有的radius参数
    init(x: Int = 0, y: Int = 0, color: String = "黑色", radius: Double = 1.0) {
        // 先设置半径属性
        self.radius = radius
        // 调用父类初始化方法
        super.init(x: x, y: y, color: color)
    }
    
    // 重写clone方法，创建圆形的副本
    override func clone() -> Self {
        // 创建新的PrototypeCircle实例，复制所有属性包括radius
        return PrototypeCircle(x: self.x, y: self.y, color: self.color, radius: self.radius) as! Self
    }
    
    // 重写describe方法，返回圆形的描述信息
    override func describe() -> String {
        // 返回包含位置、颜色和半径的描述字符串
        return "圆形在位置(\(x), \(y))，颜色: \(color)，半径: \(radius)"
    }
}

// 原型矩形类，继承自PrototypeShape
class PrototypeRectangle: PrototypeShape {
    // 宽度属性
    var width: Double
    // 高度属性
    var height: Double
    
    // 初始化方法，包含矩形特有的width和height参数
    init(x: Int = 0, y: Int = 0, color: String = "黑色", width: Double = 1.0, height: Double = 1.0) {
        // 先设置宽度属性
        self.width = width
        // 设置高度属性
        self.height = height
        // 调用父类初始化方法
        super.init(x: x, y: y, color: color)
    }
    
    // 重写clone方法，创建矩形的副本
    override func clone() -> Self {
        // 创建新的PrototypeRectangle实例，复制所有属性包括width和height
        return PrototypeRectangle(x: self.x, y: self.y, color: self.color, width: self.width, height: self.height) as! Self
    }
    
    // 重写describe方法，返回矩形的描述信息
    override func describe() -> String {
        // 返回包含位置、颜色和尺寸的描述字符串
        return "矩形在位置(\(x), \(y))，颜色: \(color)，尺寸: \(width) × \(height)"
    }
}

