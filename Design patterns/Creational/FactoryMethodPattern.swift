//
//  FactoryMethodPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 工厂方法模式

// 运输工具协议，定义所有运输工具必须实现的方法
protocol Transport {
    // 交付货物的方法
    func deliver()
}

// 卡车类，实现Transport协议
class Truck: Transport {
    // 实现deliver方法，用卡车运输
    func deliver() {
        // 打印卡车运输信息
        print("用卡车运输货物")
    }
}

// 船舶类，实现Transport协议
class Ship: Transport {
    // 实现deliver方法，用船运输
    func deliver() {
        // 打印船舶运输信息
        print("用船运输货物")
    }
}

// 飞机类，实现Transport协议
class Airplane: Transport {
    // 实现deliver方法，用飞机运输
    func deliver() {
        // 打印飞机运输信息
        print("用飞机运输货物")
    }
}

// 物流协议，定义创建运输工具和规划交付的方法
protocol Logistics {
    // 工厂方法：创建运输工具（由子类实现具体创建逻辑）
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
    // 实现工厂方法，创建卡车运输工具
    func createTransport() -> Transport {
        // 返回卡车实例
        return Truck()
    }
}

// 海运物流类，实现Logistics协议
class SeaLogistics: Logistics {
    // 实现工厂方法，创建船舶运输工具
    func createTransport() -> Transport {
        // 返回船舶实例
        return Ship()
    }
}

// 空运物流类，实现Logistics协议
class AirLogistics: Logistics {
    // 实现工厂方法，创建飞机运输工具
    func createTransport() -> Transport {
        // 返回飞机实例
        return Airplane()
    }
}

