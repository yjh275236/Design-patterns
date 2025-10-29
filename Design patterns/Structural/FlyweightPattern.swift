//
//  FlyweightPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 享元模式

struct IntrinsicState {
    let color: String
    let shape: String
}

class TreeType {
    let name: String
    let color: String
    let texture: String
    
    init(name: String, color: String, texture: String) {
        self.name = name
        self.color = color
        self.texture = texture
    }
    
    func draw(x: Int, y: Int) -> String {
        return "在(\(x), \(y))绘制\(color)的\(name)树，纹理: \(texture)"
    }
}

class TreeFactory {
    private static var treeTypes: [String: TreeType] = [:]
    
    static func getTreeType(name: String, color: String, texture: String) -> TreeType {
        let key = "\(name)_\(color)_\(texture)"
        
        if let existing = treeTypes[key] {
            return existing
        }
        
        let newType = TreeType(name: name, color: color, texture: texture)
        treeTypes[key] = newType
        print("创建新的树类型: \(key)")
        return newType
    }
    
    static func getTreeCount() -> Int {
        return treeTypes.count
    }
}

class Tree {
    let x: Int
    let y: Int
    let type: TreeType
    
    init(x: Int, y: Int, type: TreeType) {
        self.x = x
        self.y = y
        self.type = type
    }
    
    func draw() -> String {
        return type.draw(x: x, y: y)
    }
}

