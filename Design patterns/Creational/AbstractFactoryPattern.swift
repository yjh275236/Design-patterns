//
//  AbstractFactoryPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 抽象工厂模式
// 核心角色：UIFactory（抽象工厂）定义成对产品的创建接口，具体工厂保证产品族的一致性
// 新手提示：留意标记为“核心实现”的部分即可理解抽象工厂，其余代码只是不同风格产品的示例实现

// 按钮协议，定义按钮必须实现的方法
protocol Button {
    // 渲染按钮的方法
    func render()
}

// 复选框协议，定义复选框必须实现的方法
protocol Checkbox {
    // 渲染复选框的方法
    func render()
}

// Mac风格的按钮类，实现Button协议
class MacButton: Button {
    // 演示实现：Mac风格的按钮外观
    func render() {
        // 打印Mac风格按钮的渲染信息
        print("渲染 Mac 风格的按钮")
    }
}

// Mac风格的复选框类，实现Checkbox协议
class MacCheckbox: Checkbox {
    // 演示实现：Mac风格的复选框外观
    func render() {
        // 打印Mac风格复选框的渲染信息
        print("渲染 Mac 风格的复选框")
    }
}

// Windows风格的按钮类，实现Button协议
class WindowsButton: Button {
    // 演示实现：Windows风格的按钮外观
    func render() {
        // 打印Windows风格按钮的渲染信息
        print("渲染 Windows 风格的按钮")
    }
}

// Windows风格的复选框类，实现Checkbox协议
class WindowsCheckbox: Checkbox {
    // 演示实现：Windows风格的复选框外观
    func render() {
        // 打印Windows风格复选框的渲染信息
        print("渲染 Windows 风格的复选框")
    }
}

// UI工厂协议，定义创建UI组件的工厂方法
protocol UIFactory {
    // 核心实现：创建同一产品族的按钮
    func createButton() -> Button
    // 核心实现：创建同一产品族的复选框
    func createCheckbox() -> Checkbox
}

// Mac UI工厂类，实现UIFactory协议，创建Mac风格的UI组件
class MacUIFactory: UIFactory {
    // 核心实现：返回Mac风格按钮
    func createButton() -> Button {
        // 返回Mac按钮实例
        return MacButton()
    }
    
    // 核心实现：返回Mac风格复选框
    func createCheckbox() -> Checkbox {
        // 返回Mac复选框实例
        return MacCheckbox()
    }
}

// Windows UI工厂类，实现UIFactory协议，创建Windows风格的UI组件
class WindowsUIFactory: UIFactory {
    // 核心实现：返回Windows风格按钮
    func createButton() -> Button {
        // 返回Windows按钮实例
        return WindowsButton()
    }
    
    // 核心实现：返回Windows风格复选框
    func createCheckbox() -> Checkbox {
        // 返回Windows复选框实例
        return WindowsCheckbox()
    }
}

// 使用示例（通过抽象工厂切换整套组件风格）：
// func buildUI(using factory: UIFactory) {
//     let button = factory.createButton()          // 核心：通过工厂获取配套产品
//     let checkbox = factory.createCheckbox()
//     button.render()
//     checkbox.render()
// }
// buildUI(using: MacUIFactory())                  // 替换工厂即可渲染不同风格

