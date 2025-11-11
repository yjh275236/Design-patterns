//
//  ObserverPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 观察者模式

// 观察者协议，定义观察者的接口，使用AnyObject限制为类类型
protocol Observer: AnyObject {
    // 更新方法，接收被观察者的状态变化
    func update(temperature: Double, humidity: Double, pressure: Double)
}

// 主题协议，定义被观察者的接口
protocol Subject {
    // 注册观察者的方法
    func registerObserver(_ observer: Observer)
    // 移除观察者的方法
    func removeObserver(_ observer: Observer)
    // 通知所有观察者的方法
    func notifyObservers()
}

// 天气数据类，实现Subject协议，代表被观察的主题
class WeatherData: Subject {
    // 私有属性：存储观察者的数组
    private var observers: [Observer] = []
    // 私有属性：温度数据
    private var temperature: Double = 0
    // 私有属性：湿度数据
    private var humidity: Double = 0
    // 私有属性：气压数据
    private var pressure: Double = 0
    
    // 实现registerObserver方法，注册观察者
    func registerObserver(_ observer: Observer) {
        // 将观察者添加到数组中
        observers.append(observer)
    }
    
    // 实现removeObserver方法，移除观察者
    func removeObserver(_ observer: Observer) {
        // 从数组中移除指定的观察者（使用引用相等性比较）
        observers.removeAll { $0 === observer }
    }
    
    // 实现notifyObservers方法，通知所有观察者
    func notifyObservers() {
        // 遍历所有观察者
        for observer in observers {
            // 调用每个观察者的update方法，传递最新数据
            observer.update(temperature: temperature, humidity: humidity, pressure: pressure)
        }
    }
    
    // 设置测量数据的方法
    func setMeasurements(temperature: Double, humidity: Double, pressure: Double) {
        // 更新温度数据
        self.temperature = temperature
        // 更新湿度数据
        self.humidity = humidity
        // 更新气压数据
        self.pressure = pressure
        // 通知所有观察者数据已更新
        notifyObservers()
    }
}

// 当前状况显示类，实现Observer协议，显示当前天气状况
class CurrentConditionsDisplay: Observer {
    // 实现update方法，接收天气数据更新
    func update(temperature: Double, humidity: Double, pressure: Double) {
        // 打印当前天气状况信息
        print("当前天气状况 - 温度: \(temperature)°C, 湿度: \(humidity)%, 气压: \(pressure)hPa")
    }
}

// 统计显示类，实现Observer协议，显示统计信息
class StatisticsDisplay: Observer {
    // 实现update方法，接收天气数据更新
    func update(temperature: Double, humidity: Double, pressure: Double) {
        // 打印统计信息（这里只显示温度）
        print("统计显示 - 温度: \(temperature)°C")
    }
}

