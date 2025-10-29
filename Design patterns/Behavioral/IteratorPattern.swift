//
//  IteratorPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 迭代器模式

protocol Iterator {
    func hasNext() -> Bool
    func next() -> String?
}

protocol Container {
    func getIterator() -> Iterator
}

class NameRepository: Container {
    private let names = ["张三", "李四", "王五", "赵六"]
    
    func getIterator() -> Iterator {
        return NameIterator(names: names)
    }
}

class NameIterator: Iterator {
    private let names: [String]
    private var index = 0
    
    init(names: [String]) {
        self.names = names
    }
    
    func hasNext() -> Bool {
        return index < names.count
    }
    
    func next() -> String? {
        if hasNext() {
            let name = names[index]
            index += 1
            return name
        }
        return nil
    }
}

