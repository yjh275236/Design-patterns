//
//  CommandPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 命令模式
// 核心角色：Command 抽象封装请求，Invoker（RemoteControl）触发命令，Receiver（Light）执行实际动作
// 新手提示：重点关注“核心实现”标记的 execute/undo 与命令对象组合，其余内容仅为样例

// 命令协议，定义命令的统一接口
protocol Command {
    // 执行命令的方法
    func execute()
    // 撤销命令的方法
    func undo()
}

// 灯类，代表接收者（执行实际操作的类）
class Light {
    // 开灯的方法
    func turnOn() -> String {
        // 返回开灯的状态信息
        return "灯已打开"
    }
    
    // 关灯的方法
    func turnOff() -> String {
        // 返回关灯的状态信息
        return "灯已关闭"
    }
}

// 开灯命令类，实现Command协议
class LightOnCommand: Command {
    // 私有属性：持有灯对象的引用
    private let light: Light
    
    // 初始化方法，接收要控制的灯对象
    init(light: Light) {
        // 保存灯对象引用
        self.light = light
    }
    
    // 实现execute方法，执行开灯命令
    func execute() {
        // 调用灯的开灯方法并打印结果
        print(light.turnOn())
    }
    
    // 实现undo方法，撤销开灯命令（即关灯）
    func undo() {
        // 调用灯的关灯方法并打印结果
        print(light.turnOff())
    }
}

// 关灯命令类，实现Command协议
class LightOffCommand: Command {
    // 私有属性：持有灯对象的引用
    private let light: Light
    
    // 初始化方法，接收要控制的灯对象
    init(light: Light) {
        // 保存灯对象引用
        self.light = light
    }
    
    // 实现execute方法，执行关灯命令
    func execute() {
        // 调用灯的关灯方法并打印结果
        print(light.turnOff())
    }
    
    // 实现undo方法，撤销关灯命令（即开灯）
    func undo() {
        // 调用灯的开灯方法并打印结果
        print(light.turnOn())
    }
}

// 遥控器类，代表调用者（触发命令的类）
class RemoteControl {
    // 私有属性：当前设置的命令（可选）
    private var command: Command?
    
    // 核心实现：Invoker 通过注入命令对象来触发不同操作
    func setCommand(command: Command) {
        // 保存命令引用
        self.command = command
    }
    
    // 按下按钮的方法，执行命令
    func pressButton() -> String? {
        // 核心实现：调用命令对象，解耦调用者与接收者
        command?.execute()
        // 返回操作结果信息
        return "按钮已按下"
    }
    
    // 按下撤销按钮的方法，撤销命令
    func pressUndo() -> String? {
        // 撤销当前设置的命令
        command?.undo()
        // 返回操作结果信息
        return "撤销操作"
    }
}

// 使用示例（在运行时将不同命令绑定到同一个调用者）：
// let light = Light()
// let remote = RemoteControl()
// remote.setCommand(command: LightOnCommand(light: light))   // 核心：将请求封装成命令对象
// remote.pressButton()
// remote.pressUndo()

