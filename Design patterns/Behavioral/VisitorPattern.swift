//
//  VisitorPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 访问者模式

protocol ComputerPart {
    func accept(visitor: ComputerPartVisitor) -> String
}

protocol ComputerPartVisitor {
    func visit(computer: Computer) -> String
    func visit(mouse: Mouse) -> String
    func visit(keyboard: Keyboard) -> String
    func visit(monitor: Monitor) -> String
}

class Computer: ComputerPart {
    private var parts: [ComputerPart] = []
    
    init() {
        parts = [Mouse(), Keyboard(), Monitor()]
    }
    
    func accept(visitor: ComputerPartVisitor) -> String {
        var result = "访问计算机\n"
        for part in parts {
            result += part.accept(visitor: visitor) + "\n"
        }
        return result
    }
}

class Mouse: ComputerPart {
    func accept(visitor: ComputerPartVisitor) -> String {
        return visitor.visit(mouse: self)
    }
}

class Keyboard: ComputerPart {
    func accept(visitor: ComputerPartVisitor) -> String {
        return visitor.visit(keyboard: self)
    }
}

class Monitor: ComputerPart {
    func accept(visitor: ComputerPartVisitor) -> String {
        return visitor.visit(monitor: self)
    }
}

class ComputerPartDisplayVisitor: ComputerPartVisitor {
    func visit(computer: Computer) -> String {
        return "显示计算机"
    }
    
    func visit(mouse: Mouse) -> String {
        return "显示鼠标"
    }
    
    func visit(keyboard: Keyboard) -> String {
        return "显示键盘"
    }
    
    func visit(monitor: Monitor) -> String {
        return "显示显示器"
    }
}

class ComputerPartRepairVisitor: ComputerPartVisitor {
    func visit(computer: Computer) -> String {
        return "修理计算机"
    }
    
    func visit(mouse: Mouse) -> String {
        return "修理鼠标"
    }
    
    func visit(keyboard: Keyboard) -> String {
        return "修理键盘"
    }
    
    func visit(monitor: Monitor) -> String {
        return "修理显示器"
    }
}

