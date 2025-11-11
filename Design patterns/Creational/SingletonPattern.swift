//
//  SingletonPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 单例模式

// 数据库管理器类，使用单例模式确保整个应用只有一个实例
class DatabaseManager {
    // 静态常量属性，存储唯一的单例实例（线程安全，Swift中let是线程安全的）
    static let shared = DatabaseManager()
    
    // 私有属性：跟踪当前连接数
    private var connectionCount = 0
    
    // 私有初始化方法，防止外部通过构造函数创建新实例
    private init() {
        // 私有构造函数，防止外部创建实例
        // 打印初始化信息
        print("数据库管理器已初始化")
    }
    
    // 公共方法：连接到数据库
    func connect() {
        // 增加连接计数
        connectionCount += 1
        // 打印连接信息，显示当前连接数
        print("已连接到数据库 (连接数: \(connectionCount))")
    }
    
    // 公共方法：断开数据库连接
    func disconnect() {
        // 减少连接计数，使用max确保不会小于0
        connectionCount = max(0, connectionCount - 1)
        // 打印断开连接信息，显示剩余连接数
        print("已断开数据库连接 (剩余连接数: \(connectionCount))")
    }
    
    // 公共方法：获取当前连接数
    func getConnectionCount() -> Int {
        // 返回当前连接数
        return connectionCount
    }
}

