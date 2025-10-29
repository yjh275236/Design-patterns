//
//  ObserverPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 观察者模式

protocol Observer: AnyObject {
    func update(temperature: Double, humidity: Double, pressure: Double)
}

protocol Subject {
    func registerObserver(_ observer: Observer)
    func removeObserver(_ observer: Observer)
    func notifyObservers()
}

class WeatherData: Subject {
    private var observers: [Observer] = []
    private var temperature: Double = 0
    private var humidity: Double = 0
    private var pressure: Double = 0
    
    func registerObserver(_ observer: Observer) {
        observers.append(observer)
    }
    
    func removeObserver(_ observer: Observer) {
        observers.removeAll { $0 === observer }
    }
    
    func notifyObservers() {
        for observer in observers {
            observer.update(temperature: temperature, humidity: humidity, pressure: pressure)
        }
    }
    
    func setMeasurements(temperature: Double, humidity: Double, pressure: Double) {
        self.temperature = temperature
        self.humidity = humidity
        self.pressure = pressure
        notifyObservers()
    }
}

class CurrentConditionsDisplay: Observer {
    func update(temperature: Double, humidity: Double, pressure: Double) {
        print("当前天气状况 - 温度: \(temperature)°C, 湿度: \(humidity)%, 气压: \(pressure)hPa")
    }
}

class StatisticsDisplay: Observer {
    func update(temperature: Double, humidity: Double, pressure: Double) {
        print("统计显示 - 温度: \(temperature)°C")
    }
}

