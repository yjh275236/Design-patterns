//
//  CommandPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 命令模式

protocol Command {
    func execute()
    func undo()
}

class Light {
    func turnOn() -> String {
        return "灯已打开"
    }
    
    func turnOff() -> String {
        return "灯已关闭"
    }
}

class LightOnCommand: Command {
    private let light: Light
    
    init(light: Light) {
        self.light = light
    }
    
    func execute() {
        print(light.turnOn())
    }
    
    func undo() {
        print(light.turnOff())
    }
}

class LightOffCommand: Command {
    private let light: Light
    
    init(light: Light) {
        self.light = light
    }
    
    func execute() {
        print(light.turnOff())
    }
    
    func undo() {
        print(light.turnOn())
    }
}

class RemoteControl {
    private var command: Command?
    
    func setCommand(command: Command) {
        self.command = command
    }
    
    func pressButton() -> String? {
        command?.execute()
        return "按钮已按下"
    }
    
    func pressUndo() -> String? {
        command?.undo()
        return "撤销操作"
    }
}

