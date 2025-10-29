//
//  BuilderPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 建造者模式

class Pizza {
    var dough: String = ""
    var sauce: String = ""
    var cheese: String = ""
    var toppings: [String] = []
    
    func description() -> String {
        var desc = "披萨: "
        if !dough.isEmpty { desc += "\(dough)面团, " }
        if !sauce.isEmpty { desc += "\(sauce)酱, " }
        if !cheese.isEmpty { desc += "\(cheese)奶酪, " }
        if !toppings.isEmpty { desc += "配料: \(toppings.joined(separator: ", "))" }
        return desc
    }
}

protocol PizzaBuilder {
    func setDough(_ dough: String)
    func setSauce(_ sauce: String)
    func setCheese(_ cheese: String)
    func addTopping(_ topping: String)
    func build() -> Pizza
}

class ConcretePizzaBuilder: PizzaBuilder {
    private var pizza = Pizza()
    
    func setDough(_ dough: String) {
        pizza.dough = dough
    }
    
    func setSauce(_ sauce: String) {
        pizza.sauce = sauce
    }
    
    func setCheese(_ cheese: String) {
        pizza.cheese = cheese
    }
    
    func addTopping(_ topping: String) {
        pizza.toppings.append(topping)
    }
    
    func build() -> Pizza {
        let result = pizza
        pizza = Pizza() // 重置以构建新的披萨
        return result
    }
}

class PizzaDirector {
    private var builder: PizzaBuilder
    
    init(builder: PizzaBuilder) {
        self.builder = builder
    }
    
    func makeMargherita() -> Pizza {
        builder.setDough("薄脆")
        builder.setSauce("番茄")
        builder.setCheese("马苏里拉")
        return builder.build()
    }
    
    func makePepperoni() -> Pizza {
        builder.setDough("厚底")
        builder.setSauce("番茄")
        builder.setCheese("马苏里拉")
        builder.addTopping("意大利辣香肠")
        builder.addTopping("橄榄")
        return builder.build()
    }
}

