//
//  CompositePattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 组合模式

protocol Graphic: AnyObject {
    func draw() -> String
}

class Dot: Graphic {
    private let x: Int
    private let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    func draw() -> String {
        return "在(\(x), \(y))绘制点"
    }
}

class CompositeCircle: Graphic {
    private let x: Int
    private let y: Int
    private let radius: Int
    
    init(x: Int, y: Int, radius: Int) {
        self.x = x
        self.y = y
        self.radius = radius
    }
    
    func draw() -> String {
        return "在(\(x), \(y))绘制半径为\(radius)的圆形"
    }
}

class CompoundGraphic: Graphic {
    private var children: [Graphic] = []
    
    func add(child: Graphic) {
        children.append(child)
    }
    
    func remove(child: Graphic) {
        if let index = children.firstIndex(where: { $0 === child }) {
            children.remove(at: index)
        }
    }
    
    func draw() -> String {
        var result = "组合图形包含:\n"
        for child in children {
            result += "  - \(child.draw())\n"
        }
        return result
    }
}

