//
//  BuilderPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 建造者模式
// 核心角色：PizzaBuilder 定义构建步骤，ConcretePizzaBuilder 实现细节，PizzaDirector 负责装配顺序
// 新手提示：关注“核心实现”标记即可理解建造者模式，其余属性和方法用于演示不同配方

// 披萨产品类，包含披萨的所有组成部分
class Pizza {
    // 面团类型
    var dough: String = ""
    // 酱料类型
    var sauce: String = ""
    // 奶酪类型
    var cheese: String = ""
    // 配料数组
    var toppings: [String] = []
    
    // 返回披萨的描述信息
    func description() -> String {
        // 初始化描述字符串
        var desc = "披萨: "
        // 如果面团不为空，添加到描述中
        if !dough.isEmpty { desc += "\(dough)面团, " }
        // 如果酱料不为空，添加到描述中
        if !sauce.isEmpty { desc += "\(sauce)酱, " }
        // 如果奶酪不为空，添加到描述中
        if !cheese.isEmpty { desc += "\(cheese)奶酪, " }
        // 如果配料不为空，添加到描述中，用逗号分隔
        if !toppings.isEmpty { desc += "配料: \(toppings.joined(separator: ", "))" }
        // 返回完整描述
        return desc
    }
}

// 披萨建造者协议，定义构建披萨的各个步骤
protocol PizzaBuilder {
    // 核心实现：设置面团类型（构建步骤之一）
    func setDough(_ dough: String)
    // 核心实现：设置酱料类型
    func setSauce(_ sauce: String)
    // 核心实现：设置奶酪类型
    func setCheese(_ cheese: String)
    // 核心实现：添加配料
    func addTopping(_ topping: String)
    // 核心实现：完成构建并返回成品
    func build() -> Pizza
}

// 具体披萨建造者类，实现PizzaBuilder协议
class ConcretePizzaBuilder: PizzaBuilder {
    // 私有属性：当前正在构建的披萨对象
    private var pizza = Pizza()
    
    // 核心实现：逐步为产品设置面团
    func setDough(_ dough: String) {
        // 设置披萨的面团属性
        pizza.dough = dough
    }
    
    // 核心实现：设置酱料
    func setSauce(_ sauce: String) {
        // 设置披萨的酱料属性
        pizza.sauce = sauce
    }
    
    // 核心实现：设置奶酪
    func setCheese(_ cheese: String) {
        // 设置披萨的奶酪属性
        pizza.cheese = cheese
    }
    
    // 核心实现：添加额外配料
    func addTopping(_ topping: String) {
        // 将配料添加到披萨的配料数组中
        pizza.toppings.append(topping)
    }
    
    // 核心实现：返回当前产品并重置建造者
    func build() -> Pizza {
        // 保存当前构建的披萨
        let result = pizza
        // 重置披萨对象，以便构建新的披萨
        pizza = Pizza() // 重置以构建新的披萨
        // 返回构建完成的披萨
        return result
    }
}

// 披萨指导者类，使用建造者来创建特定类型的披萨
class PizzaDirector {
    // 私有属性：持有的建造者引用
    private var builder: PizzaBuilder
    
    // 核心实现：通过构造注入具体建造者
    init(builder: PizzaBuilder) {
        // 保存建造者引用
        self.builder = builder
    }
    
    // 演示流程：制作玛格丽塔披萨的固定步骤
    func makeMargherita() -> Pizza {
        // 设置薄脆面团
        builder.setDough("薄脆")
        // 设置番茄酱
        builder.setSauce("番茄")
        // 设置马苏里拉奶酪
        builder.setCheese("马苏里拉")
        // 构建并返回披萨
        return builder.build()
    }
    
    // 制作意大利辣香肠披萨的方法
    func makePepperoni() -> Pizza {
        // 设置厚底面团
        builder.setDough("厚底")
        // 设置番茄酱
        builder.setSauce("番茄")
        // 设置马苏里拉奶酪
        builder.setCheese("马苏里拉")
        // 添加意大利辣香肠配料
        builder.addTopping("意大利辣香肠")
        // 添加橄榄配料
        builder.addTopping("橄榄")
        // 构建并返回披萨
        return builder.build()
    }
}

// 使用示例（在需要的位置创建建造者和导演）：
// let builder = ConcretePizzaBuilder()           // 核心：选择具体建造者
// let director = PizzaDirector(builder: builder) // 导演负责组织步骤
// let pizza = director.makePepperoni()           // 返回已按步骤构建好的披萨
// print(pizza.description())                     // 查看最终产品描述

