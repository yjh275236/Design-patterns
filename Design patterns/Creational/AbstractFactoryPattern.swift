//
//  AbstractFactoryPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 抽象工厂模式

protocol Button {
    func render()
}

protocol Checkbox {
    func render()
}

class MacButton: Button {
    func render() {
        print("渲染 Mac 风格的按钮")
    }
}

class MacCheckbox: Checkbox {
    func render() {
        print("渲染 Mac 风格的复选框")
    }
}

class WindowsButton: Button {
    func render() {
        print("渲染 Windows 风格的按钮")
    }
}

class WindowsCheckbox: Checkbox {
    func render() {
        print("渲染 Windows 风格的复选框")
    }
}

protocol UIFactory {
    func createButton() -> Button
    func createCheckbox() -> Checkbox
}

class MacUIFactory: UIFactory {
    func createButton() -> Button {
        return MacButton()
    }
    
    func createCheckbox() -> Checkbox {
        return MacCheckbox()
    }
}

class WindowsUIFactory: UIFactory {
    func createButton() -> Button {
        return WindowsButton()
    }
    
    func createCheckbox() -> Checkbox {
        return WindowsCheckbox()
    }
}

