//
//  CompositePattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 组合模式
// 核心角色：CompoundGraphic（组合节点）与 Dot/CompositeCircle（叶节点）共享 Graphic 接口，实现一致操作
// 新手提示：留意“核心实现”标记部分理解组合关系，其余内容为实际图形示例

// 图形协议，定义图形的基本接口，使用AnyObject限制为类类型
protocol Graphic: AnyObject {
    // 核心实现：统一的绘制操作
    func draw() -> String
}

// 点类，实现Graphic协议，代表叶子节点
class Dot: Graphic {
    // 私有属性：x坐标
    private let x: Int
    // 私有属性：y坐标
    private let y: Int
    
    // 初始化方法，设置点的坐标
    init(x: Int, y: Int) {
        // 设置x坐标
        self.x = x
        // 设置y坐标
        self.y = y
    }
    
    // 实现draw方法，绘制点
    func draw() -> String {
        // 返回绘制点的描述，包含坐标信息
        return "在(\(x), \(y))绘制点"
    }
}

// 圆形类，实现Graphic协议，代表叶子节点
class CompositeCircle: Graphic {
    // 私有属性：x坐标
    private let x: Int
    // 私有属性：y坐标
    private let y: Int
    // 私有属性：半径
    private let radius: Int
    
    // 初始化方法，设置圆形的位置和半径
    init(x: Int, y: Int, radius: Int) {
        // 设置x坐标
        self.x = x
        // 设置y坐标
        self.y = y
        // 设置半径
        self.radius = radius
    }
    
    // 实现draw方法，绘制圆形
    func draw() -> String {
        // 返回绘制圆形的描述，包含位置和半径信息
        return "在(\(x), \(y))绘制半径为\(radius)的圆形"
    }
}

// 组合图形类，实现Graphic协议，代表组合节点（容器）
class CompoundGraphic: Graphic {
    // 私有属性：存储子图形对象的数组
    private var children: [Graphic] = []
    
    // 核心实现：在组合中添加子节点
    func add(child: Graphic) {
        // 将子图形添加到数组中
        children.append(child)
    }
    
    // 核心实现：从组合中移除子节点
    func remove(child: Graphic) {
        // 查找子图形在数组中的索引位置（使用引用相等性比较）
        if let index = children.firstIndex(where: { $0 === child }) {
            // 如果找到，从数组中移除
            children.remove(at: index)
        }
    }
    
    // 核心实现：遍历并委托子节点执行同样的操作
    func draw() -> String {
        // 初始化结果字符串
        var result = "组合图形包含:\n"
        // 遍历所有子图形
        for child in children {
            // 递归调用每个子图形的draw方法，并添加到结果中
            result += "  - \(child.draw())\n"
        }
        // 返回组合图形的描述
        return result
    }
}

// 使用示例（客户端无需区分叶子或组合，直接调用统一接口）：
// let dot: Graphic = Dot(x: 1, y: 2)
// let circle: Graphic = CompositeCircle(x: 5, y: 5, radius: 3)
// let compound = CompoundGraphic()
// compound.add(child: dot)
// compound.add(child: circle)
// print(compound.draw())                        // 核心：组合节点与叶子节点拥有一致的操作

