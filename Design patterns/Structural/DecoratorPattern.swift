//
//  DecoratorPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 装饰模式

// 咖啡协议，定义咖啡的基本接口
protocol Coffee {
    // 计算价格的方法
    func cost() -> Double
    // 获取描述的方法
    func description() -> String
}

// 简单咖啡类，实现Coffee协议，代表基础组件
class SimpleCoffee: Coffee {
    // 实现cost方法，返回基础价格
    func cost() -> Double {
        // 返回基础咖啡价格
        return 5.0
    }
    
    // 实现description方法，返回基础描述
    func description() -> String {
        // 返回基础咖啡描述
        return "普通咖啡"
    }
}

// 咖啡装饰器抽象类，实现Coffee协议，是所有装饰器的基类
class CoffeeDecorator: Coffee {
    // 私有属性：持有被装饰的咖啡对象的引用
    private let coffee: Coffee
    
    // 初始化方法，接收要装饰的咖啡对象
    init(coffee: Coffee) {
        // 保存咖啡对象引用
        self.coffee = coffee
    }
    
    // 实现cost方法，默认返回被装饰对象的价格
    func cost() -> Double {
        // 返回被装饰咖啡的价格
        return coffee.cost()
    }
    
    // 实现description方法，默认返回被装饰对象的描述
    func description() -> String {
        // 返回被装饰咖啡的描述
        return coffee.description()
    }
}

// 牛奶装饰器类，继承自CoffeeDecorator，添加牛奶功能
class MilkDecorator: CoffeeDecorator {
    // 重写cost方法，在基础价格上添加牛奶价格
    override func cost() -> Double {
        // 调用父类方法获取基础价格，然后加上牛奶价格
        return super.cost() + 2.0
    }
    
    // 重写description方法，在基础描述上添加牛奶描述
    override func description() -> String {
        // 调用父类方法获取基础描述，然后添加牛奶描述
        return super.description() + ", 加牛奶"
    }
}

// 糖装饰器类，继承自CoffeeDecorator，添加糖功能
class SugarDecorator: CoffeeDecorator {
    // 重写cost方法，在基础价格上添加糖价格
    override func cost() -> Double {
        // 调用父类方法获取基础价格，然后加上糖价格
        return super.cost() + 1.0
    }
    
    // 重写description方法，在基础描述上添加糖描述
    override func description() -> String {
        // 调用父类方法获取基础描述，然后添加糖描述
        return super.description() + ", 加糖"
    }
}

// 奶油装饰器类，继承自CoffeeDecorator，添加奶油功能
class WhipDecorator: CoffeeDecorator {
    // 重写cost方法，在基础价格上添加奶油价格
    override func cost() -> Double {
        // 调用父类方法获取基础价格，然后加上奶油价格
        return super.cost() + 1.5
    }
    
    // 重写description方法，在基础描述上添加奶油描述
    override func description() -> String {
        // 调用父类方法获取基础描述，然后添加奶油描述
        return super.description() + ", 加奶油"
    }
}

