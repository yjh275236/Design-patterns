//
//  FactoryMethodPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 工厂方法模式
// 核心角色：Logistics（创建者）定义工厂方法，Transport（产品）由子类决定具体实现
// 新手提示：标记为“核心实现”的代码是真正体现工厂方法模式的部分，其余逻辑用于演示业务流程

// 运输工具协议，定义所有运输工具必须实现的方法
protocol Transport {
    // 交付货物的方法
    func deliver()
}

// 卡车类，实现Transport协议
class Truck: Transport {
    // 演示实现：卡车交付方式
    func deliver() {
        // 打印卡车运输信息
        print("用卡车运输货物")
    }
}

// 船舶类，实现Transport协议
class Ship: Transport {
    // 演示实现：船舶交付方式
    func deliver() {
        // 打印船舶运输信息
        print("用船运输货物")
    }
}

// 飞机类，实现Transport协议
class Airplane: Transport {
    // 演示实现：飞机交付方式
    func deliver() {
        // 打印飞机运输信息
        print("用飞机运输货物")
    }
}

// 物流协议，定义创建运输工具和规划交付的方法
protocol Logistics {
    // 核心实现：工厂方法，由子类决定创建哪种Transport
    func createTransport() -> Transport
    // 规划交付流程的方法
    func planDelivery()
}

// 扩展Logistics协议，提供planDelivery的默认实现
extension Logistics {
    // 默认的交付规划实现
    func planDelivery() {
        // 调用工厂方法创建运输工具
        let transport = createTransport()
        // 使用创建的运输工具进行交付
        transport.deliver()
    }
}

// 公路物流类，实现Logistics协议
class RoadLogistics: Logistics {
    // 核心实现：返回卡车，体现“由子类决定产品类型”
    func createTransport() -> Transport {
        // 返回卡车实例
        return Truck()
    }
}

// 海运物流类，实现Logistics协议
class SeaLogistics: Logistics {
    // 核心实现：返回船舶
    func createTransport() -> Transport {
        // 返回船舶实例
        return Ship()
    }
}

// 空运物流类，实现Logistics协议
class AirLogistics: Logistics {
    // 核心实现：返回飞机
    func createTransport() -> Transport {
        // 返回飞机实例
        return Airplane()
    }
}

// 使用示例（在调用处选择不同的工厂实现）：
// let logistics: Logistics = SeaLogistics()   // 核心点：通过抽象类型持有具体工厂
// logistics.planDelivery()                    // 运行时会创建并使用对应的Transport

