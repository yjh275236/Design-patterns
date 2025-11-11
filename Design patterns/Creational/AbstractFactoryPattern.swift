//
//  AbstractFactoryPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 抽象工厂模式

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
    // 实现render方法，渲染Mac风格的按钮
    func render() {
        // 打印Mac风格按钮的渲染信息
        print("渲染 Mac 风格的按钮")
    }
}

// Mac风格的复选框类，实现Checkbox协议
class MacCheckbox: Checkbox {
    // 实现render方法，渲染Mac风格的复选框
    func render() {
        // 打印Mac风格复选框的渲染信息
        print("渲染 Mac 风格的复选框")
    }
}

// Windows风格的按钮类，实现Button协议
class WindowsButton: Button {
    // 实现render方法，渲染Windows风格的按钮
    func render() {
        // 打印Windows风格按钮的渲染信息
        print("渲染 Windows 风格的按钮")
    }
}

// Windows风格的复选框类，实现Checkbox协议
class WindowsCheckbox: Checkbox {
    // 实现render方法，渲染Windows风格的复选框
    func render() {
        // 打印Windows风格复选框的渲染信息
        print("渲染 Windows 风格的复选框")
    }
}

// UI工厂协议，定义创建UI组件的工厂方法
protocol UIFactory {
    // 创建按钮的工厂方法
    func createButton() -> Button
    // 创建复选框的工厂方法
    func createCheckbox() -> Checkbox
}

// Mac UI工厂类，实现UIFactory协议，创建Mac风格的UI组件
class MacUIFactory: UIFactory {
    // 实现createButton方法，创建Mac风格的按钮
    func createButton() -> Button {
        // 返回Mac按钮实例
        return MacButton()
    }
    
    // 实现createCheckbox方法，创建Mac风格的复选框
    func createCheckbox() -> Checkbox {
        // 返回Mac复选框实例
        return MacCheckbox()
    }
}

// Windows UI工厂类，实现UIFactory协议，创建Windows风格的UI组件
class WindowsUIFactory: UIFactory {
    // 实现createButton方法，创建Windows风格的按钮
    func createButton() -> Button {
        // 返回Windows按钮实例
        return WindowsButton()
    }
    
    // 实现createCheckbox方法，创建Windows风格的复选框
    func createCheckbox() -> Checkbox {
        // 返回Windows复选框实例
        return WindowsCheckbox()
    }
}

