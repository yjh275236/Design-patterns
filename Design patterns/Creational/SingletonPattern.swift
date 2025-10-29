//
//  SingletonPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 单例模式

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private var connectionCount = 0
    
    private init() {
        // 私有构造函数，防止外部创建实例
        print("数据库管理器已初始化")
    }
    
    func connect() {
        connectionCount += 1
        print("已连接到数据库 (连接数: \(connectionCount))")
    }
    
    func disconnect() {
        connectionCount = max(0, connectionCount - 1)
        print("已断开数据库连接 (剩余连接数: \(connectionCount))")
    }
    
    func getConnectionCount() -> Int {
        return connectionCount
    }
}

