//
//  VisitorPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 访问者模式
// 核心角色：ComputerPart（元素）定义 accept，Visitor 提供针对不同元素的 visit 实现
// 新手提示：关注“核心实现”标记，理解双派发如何根据元素/访问者组合执行不同操作

// 电脑部件协议，定义接受访问者的接口
protocol ComputerPart {
    // 核心实现：接受访问者并将自己传递给访问者
    func accept(visitor: ComputerPartVisitor) -> String
}

// 电脑部件访问者协议，定义访问各种部件的方法
protocol ComputerPartVisitor {
    // 访问电脑的方法
    func visit(computer: Computer) -> String
    // 访问鼠标的方法
    func visit(mouse: Mouse) -> String
    // 访问键盘的方法
    func visit(keyboard: Keyboard) -> String
    // 访问显示器的方法
    func visit(monitor: Monitor) -> String
}

// 电脑类，实现ComputerPart协议，包含多个部件
class Computer: ComputerPart {
    // 私有属性：存储电脑部件的数组
    private var parts: [ComputerPart] = []
    
    // 初始化方法，创建电脑的各个部件
    init() {
        // 初始化部件数组，包含鼠标、键盘和显示器
        parts = [Mouse(), Keyboard(), Monitor()]
    }
    
    // 实现accept方法，接受访问者访问
    func accept(visitor: ComputerPartVisitor) -> String {
        // 初始化结果字符串
        var result = "访问计算机\n"
        // 遍历所有部件
        for part in parts {
            // 核心实现：元素将访问者传递给子元素
            result += part.accept(visitor: visitor) + "\n"
        }
        // 返回访问结果
        return result
    }
}

// 鼠标类，实现ComputerPart协议
class Mouse: ComputerPart {
    // 实现accept方法，接受访问者访问
    func accept(visitor: ComputerPartVisitor) -> String {
        // 核心实现：反向调用访问者上的匹配方法
        return visitor.visit(mouse: self)
    }
}

// 键盘类，实现ComputerPart协议
class Keyboard: ComputerPart {
    // 实现accept方法，接受访问者访问
    func accept(visitor: ComputerPartVisitor) -> String {
        // 核心实现：反向调用访问者上的匹配方法
        return visitor.visit(keyboard: self)
    }
}

// 显示器类，实现ComputerPart协议
class Monitor: ComputerPart {
    // 实现accept方法，接受访问者访问
    func accept(visitor: ComputerPartVisitor) -> String {
        // 核心实现：反向调用访问者上的匹配方法
        return visitor.visit(monitor: self)
    }
}

// 电脑部件显示访问者类，实现ComputerPartVisitor协议，用于显示部件
class ComputerPartDisplayVisitor: ComputerPartVisitor {
    // 实现visit方法，访问电脑
    func visit(computer: Computer) -> String {
        // 返回显示电脑的信息
        return "显示计算机"
    }
    
    // 实现visit方法，访问鼠标
    func visit(mouse: Mouse) -> String {
        // 返回显示鼠标的信息
        return "显示鼠标"
    }
    
    // 实现visit方法，访问键盘
    func visit(keyboard: Keyboard) -> String {
        // 返回显示键盘的信息
        return "显示键盘"
    }
    
    // 实现visit方法，访问显示器
    func visit(monitor: Monitor) -> String {
        // 返回显示显示器的信息
        return "显示显示器"
    }
}

// 电脑部件修理访问者类，实现ComputerPartVisitor协议，用于修理部件
class ComputerPartRepairVisitor: ComputerPartVisitor {
    // 实现visit方法，访问电脑
    func visit(computer: Computer) -> String {
        // 返回修理电脑的信息
        return "修理计算机"
    }
    
    // 实现visit方法，访问鼠标
    func visit(mouse: Mouse) -> String {
        // 返回修理鼠标的信息
        return "修理鼠标"
    }
    
    // 实现visit方法，访问键盘
    func visit(keyboard: Keyboard) -> String {
        // 返回修理键盘的信息
        return "修理键盘"
    }
    
    // 实现visit方法，访问显示器
    func visit(monitor: Monitor) -> String {
        // 返回修理显示器的信息
        return "修理显示器"
    }
}

// 使用示例（在不修改元素类的情况下添加新操作）：
// let computer = Computer()
// let displayVisitor = ComputerPartDisplayVisitor()
// print(computer.accept(visitor: displayVisitor))          // 核心：访问者决定具体操作
// let repairVisitor = ComputerPartRepairVisitor()
// print(computer.accept(visitor: repairVisitor))

