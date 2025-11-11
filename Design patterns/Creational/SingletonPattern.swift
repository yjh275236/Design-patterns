//
//  SingletonPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 单例模式
// 核心角色：DatabaseManager 作为唯一实例，负责管理数据库连接
// 新手提示：下方标记为“核心实现”的部分是理解单例模式的关键，其余逻辑只是演示用途

// 数据库管理器类，使用单例模式确保整个应用只有一个实例
class DatabaseManager {
    // 核心实现：静态常量属性，存储唯一的单例实例（线程安全，Swift中let是线程安全的）
    static let shared = DatabaseManager()
    
    // 演示属性：记录连接数量，用于展示共享状态的效果
    private var connectionCount = 0
    
    // 核心实现：私有初始化方法，阻止外部通过构造函数再创建实例
    private init() {
        // 私有构造函数，防止外部创建实例
        // 打印初始化信息
        print("数据库管理器已初始化")
    }
    
    // 演示方法：连接到数据库（真实项目中可改为真正的连接逻辑）
    func connect() {
        // 增加连接计数
        connectionCount += 1
        // 打印连接信息，显示当前连接数
        print("已连接到数据库 (连接数: \(connectionCount))")
    }
    
    // 演示方法：断开数据库连接
    func disconnect() {
        // 减少连接计数，使用max确保不会小于0
        connectionCount = max(0, connectionCount - 1)
        // 打印断开连接信息，显示剩余连接数
        print("已断开数据库连接 (剩余连接数: \(connectionCount))")
    }
    
    // 辅助方法：获取当前连接数
    func getConnectionCount() -> Int {
        // 返回当前连接数
        return connectionCount
    }
}

// 使用示例（将以下代码放在需要的地方执行）：
// let manager = DatabaseManager.shared        // 访问唯一实例（核心调用）
// manager.connect()                           // 执行示例方法
// print(manager.getConnectionCount())         // 读取共享状态

