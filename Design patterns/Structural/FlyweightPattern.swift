//
//  FlyweightPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 享元模式

// 内部状态结构体，存储可共享的状态信息
struct IntrinsicState {
    // 颜色属性
    let color: String
    // 形状属性
    let shape: String
}

// 树类型类，存储树的内在状态（可共享的部分）
class TreeType {
    // 树名称
    let name: String
    // 树颜色
    let color: String
    // 树纹理
    let texture: String
    
    // 初始化方法，设置树类型的属性
    init(name: String, color: String, texture: String) {
        // 设置树名称
        self.name = name
        // 设置树颜色
        self.color = color
        // 设置树纹理
        self.texture = texture
    }
    
    // 绘制树的方法，接收位置参数（外部状态）
    func draw(x: Int, y: Int) -> String {
        // 返回绘制树的描述，包含位置和共享的属性
        return "在(\(x), \(y))绘制\(color)的\(name)树，纹理: \(texture)"
    }
}

// 树类型工厂类，管理树类型的创建和复用
class TreeFactory {
    // 静态字典：存储已创建的树类型，键为组合键，值为TreeType对象
    private static var treeTypes: [String: TreeType] = [:]
    
    // 静态方法：获取或创建树类型
    static func getTreeType(name: String, color: String, texture: String) -> TreeType {
        // 构造唯一键，用于标识树类型
        let key = "\(name)_\(color)_\(texture)"
        
        // 检查是否已存在该类型的树
        if let existing = treeTypes[key] {
            // 如果存在，直接返回已有的树类型（复用）
            return existing
        }
        
        // 如果不存在，创建新的树类型
        let newType = TreeType(name: name, color: color, texture: texture)
        // 将新类型存储到字典中
        treeTypes[key] = newType
        // 打印创建新类型的信息
        print("创建新的树类型: \(key)")
        // 返回新创建的树类型
        return newType
    }
    
    // 静态方法：获取已创建的树类型数量
    static func getTreeCount() -> Int {
        // 返回字典中树类型的数量
        return treeTypes.count
    }
}

// 树类，包含外部状态（位置）和共享的内部状态（类型）
class Tree {
    // 树的x坐标（外部状态）
    let x: Int
    // 树的y坐标（外部状态）
    let y: Int
    // 树的类型引用（共享的内部状态）
    let type: TreeType
    
    // 初始化方法，设置树的位置和类型
    init(x: Int, y: Int, type: TreeType) {
        // 设置x坐标
        self.x = x
        // 设置y坐标
        self.y = y
        // 设置树类型（共享对象）
        self.type = type
    }
    
    // 绘制树的方法
    func draw() -> String {
        // 调用树类型的draw方法，传入外部状态（位置）
        return type.draw(x: x, y: y)
    }
}

