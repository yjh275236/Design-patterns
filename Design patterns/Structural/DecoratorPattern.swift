//
//  DecoratorPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 装饰模式

protocol Coffee {
    func cost() -> Double
    func description() -> String
}

class SimpleCoffee: Coffee {
    func cost() -> Double {
        return 5.0
    }
    
    func description() -> String {
        return "普通咖啡"
    }
}

class CoffeeDecorator: Coffee {
    private let coffee: Coffee
    
    init(coffee: Coffee) {
        self.coffee = coffee
    }
    
    func cost() -> Double {
        return coffee.cost()
    }
    
    func description() -> String {
        return coffee.description()
    }
}

class MilkDecorator: CoffeeDecorator {
    override func cost() -> Double {
        return super.cost() + 2.0
    }
    
    override func description() -> String {
        return super.description() + ", 加牛奶"
    }
}

class SugarDecorator: CoffeeDecorator {
    override func cost() -> Double {
        return super.cost() + 1.0
    }
    
    override func description() -> String {
        return super.description() + ", 加糖"
    }
}

class WhipDecorator: CoffeeDecorator {
    override func cost() -> Double {
        return super.cost() + 1.5
    }
    
    override func description() -> String {
        return super.description() + ", 加奶油"
    }
}

