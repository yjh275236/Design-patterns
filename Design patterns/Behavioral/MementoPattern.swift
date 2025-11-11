//
//  MementoPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 备忘录模式

// 备忘录类，存储发起者的状态
class Memento {
    // 私有属性：存储的状态信息
    private let state: String
    
    // 初始化方法，保存状态
    init(state: String) {
        // 保存状态信息
        self.state = state
    }
    
    // 获取状态的方法
    func getState() -> String {
        // 返回保存的状态
        return state
    }
}

// 发起者类，需要保存和恢复状态的对象
class Originator {
    // 私有属性：当前状态
    private var state: String = ""
    
    // 设置状态的方法
    func setState(_ state: String) {
        // 更新当前状态
        self.state = state
    }
    
    // 获取当前状态的方法
    func getState() -> String {
        // 返回当前状态
        return state
    }
    
    // 将当前状态保存到备忘录的方法
    func saveStateToMemento() -> Memento {
        // 创建备忘录并保存当前状态
        return Memento(state: state)
    }
    
    // 从备忘录恢复状态的方法
    func getStateFromMemento(memento: Memento) {
        // 从备忘录中获取状态并恢复
        state = memento.getState()
    }
}

// 管理者类，负责保存和管理备忘录
class Caretaker {
    // 私有属性：存储备忘录的数组
    private var mementos: [Memento] = []
    
    // 添加备忘录的方法
    func add(memento: Memento) {
        // 将备忘录添加到数组中
        mementos.append(memento)
    }
    
    // 获取指定索引的备忘录的方法
    func get(index: Int) -> Memento? {
        // 检查索引是否有效
        guard index >= 0 && index < mementos.count else {
            // 如果索引无效，返回nil
            return nil
        }
        // 返回指定索引的备忘录
        return mementos[index]
    }
    
    // 获取历史记录数量的方法
    func getHistoryCount() -> Int {
        // 返回备忘录数组的长度
        return mementos.count
    }
}

