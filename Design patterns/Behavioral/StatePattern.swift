//
//  StatePattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 状态模式
// 核心角色：Context 保存当前 State，具体状态类在 handle 中决定转换
// 新手提示：关注“核心实现”标注，理解状态切换被封装在状态类中，避免上下文写大量条件

// 状态协议，定义状态的接口
protocol State {
    // 核心实现：根据当前状态处理请求，并可切换上下文状态
    func handle(context: Context) -> String
}

// 上下文类，维护当前状态的引用
class Context {
    // 私有属性：当前状态
    private var state: State
    
    // 初始化方法，设置初始状态
    init(state: State) {
        // 设置初始状态
        self.state = state
    }
    
    // 设置状态的方法
    func setState(_ state: State) {
        // 更新当前状态
        self.state = state
    }
    
    // 核心实现：将请求委托给当前状态对象
    func request() -> String {
        // 调用当前状态的handle方法
        return state.handle(context: self)
    }
    
    // 获取当前状态名称的方法
    func getCurrentState() -> String {
        // 检查当前状态类型并返回对应的名称
        if state is ConcreteStateA {
            // 如果是状态A，返回"状态A"
            return "状态A"
        } else if state is ConcreteStateB {
            // 如果是状态B，返回"状态B"
            return "状态B"
        }
        // 其他情况返回"未知状态"
        return "未知状态"
    }
}

// 具体状态A类，实现State协议
class ConcreteStateA: State {
    // 实现handle方法，处理请求并转换状态
    func handle(context: Context) -> String {
        // 核心实现：在状态内部设置下一个状态
        context.setState(ConcreteStateB())
        // 返回状态转换信息
        return "从状态A转换到状态B"
    }
}

// 具体状态B类，实现State协议
class ConcreteStateB: State {
    // 实现handle方法，处理请求并转换状态
    func handle(context: Context) -> String {
        // 核心实现：切换回另一个状态
        context.setState(ConcreteStateA())
        // 返回状态转换信息
        return "从状态B转换到状态A"
    }
}

// 使用示例（客户端只需调用 request，状态切换在内部完成）：
// let context = Context(state: ConcreteStateA())         // 核心：以某个状态初始化
// print(context.request())                               // 从状态A -> 状态B
// print(context.getCurrentState())
// print(context.request())                               // 从状态B -> 状态A

