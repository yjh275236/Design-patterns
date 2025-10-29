//
//  FactoryMethodPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 工厂方法模式

protocol Transport {
    func deliver()
}

class Truck: Transport {
    func deliver() {
        print("用卡车运输货物")
    }
}

class Ship: Transport {
    func deliver() {
        print("用船运输货物")
    }
}

class Airplane: Transport {
    func deliver() {
        print("用飞机运输货物")
    }
}

protocol Logistics {
    func createTransport() -> Transport
    func planDelivery()
}

extension Logistics {
    func planDelivery() {
        let transport = createTransport()
        transport.deliver()
    }
}

class RoadLogistics: Logistics {
    func createTransport() -> Transport {
        return Truck()
    }
}

class SeaLogistics: Logistics {
    func createTransport() -> Transport {
        return Ship()
    }
}

class AirLogistics: Logistics {
    func createTransport() -> Transport {
        return Airplane()
    }
}

