//
//  BridgePattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 桥接模式
// 核心角色：Shape（抽象部分）持有 Color（实现部分），两者解耦后可独立扩展
// 新手提示：关注“核心实现”标记即可掌握桥接思想，具体颜色和形状只是示例

// 颜色协议，定义应用颜色的方法
protocol Color {
    // 应用颜色并返回颜色名称
    func applyColor() -> String
}

// 红色类，实现Color协议
class Red: Color {
    // 演示实现：返回红色
    func applyColor() -> String {
        // 返回红色字符串
        return "红色"
    }
}

// 蓝色类，实现Color协议
class Blue: Color {
    // 演示实现：返回蓝色
    func applyColor() -> String {
        // 返回蓝色字符串
        return "蓝色"
    }
}

// 绿色类，实现Color协议
class Green: Color {
    // 演示实现：返回绿色
    func applyColor() -> String {
        // 返回绿色字符串
        return "绿色"
    }
}

// 形状协议，定义形状的接口，包含颜色属性
protocol Shape {
    // 颜色属性，可读写
    var color: Color { get set }
    // 核心实现：依赖Color接口完成绘制
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
    
    // 核心实现：将具体颜色的行为桥接到形状
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
    
    // 核心实现：调用颜色实现，组合出新的形状外观
    func draw() -> String {
        // 返回绘制正方形的描述，使用颜色
        return "绘制\(color.applyColor())的正方形"
    }
}

// 使用示例（在运行时自由组合形状与颜色）：
// let circle: Shape = BridgeCircle(color: Red())      // 核心：通过组合而非继承拓展维度
// print(circle.draw())
// circle.color = Blue()                               // 运行时替换实现部分
// print(circle.draw())

