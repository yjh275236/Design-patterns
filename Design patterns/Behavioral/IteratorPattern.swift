//
//  IteratorPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 迭代器模式
// 核心角色：Iterator 定义遍历接口，具体迭代器持有遍历状态，Container 负责创建迭代器
// 新手提示：关注“核心实现”标注的部分，理解遍历状态如何与集合解耦

// 迭代器协议，定义遍历集合的接口
protocol Iterator {
    // 核心实现：检查是否还有下一个元素
    func hasNext() -> Bool
    // 核心实现：获取下一个元素
    func next() -> String?
}

// 容器协议，定义创建迭代器的接口
protocol Container {
    // 核心实现：返回集合对应的迭代器
    func getIterator() -> Iterator
}

// 名称仓库类，实现Container协议，存储名称集合
class NameRepository: Container {
    // 私有属性：存储名称的数组
    private let names = ["张三", "李四", "王五", "赵六"]
    
    // 实现getIterator方法，返回名称迭代器
    func getIterator() -> Iterator {
        // 创建并返回名称迭代器，传入名称数组
        return NameIterator(names: names)
    }
}

// 名称迭代器类，实现Iterator协议
class NameIterator: Iterator {
    // 私有属性：存储名称的数组
    private let names: [String]
    // 私有属性：当前索引位置
    private var index = 0
    
    // 初始化方法，接收名称数组
    init(names: [String]) {
        // 保存名称数组
        self.names = names
    }
    
    // 实现hasNext方法，检查是否还有下一个元素
    func hasNext() -> Bool {
        // 返回当前索引是否小于数组长度
        return index < names.count
    }
    
    // 实现next方法，获取下一个元素
    func next() -> String? {
        // 检查是否还有下一个元素
        if hasNext() {
            // 获取当前索引位置的名称
            let name = names[index]
            // 索引向前移动一位
            index += 1
            // 返回获取的名称
            return name
        }
        // 如果没有下一个元素，返回nil
        return nil
    }
}

// 使用示例（客户端借助迭代器遍历集合）：
// let repository = NameRepository()
// let iterator = repository.getIterator()            // 核心：通过容器获取迭代器
// while iterator.hasNext() {
//     print(iterator.next() ?? "")
// }

