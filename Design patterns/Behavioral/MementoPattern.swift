//
//  MementoPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 备忘录模式

class Memento {
    private let state: String
    
    init(state: String) {
        self.state = state
    }
    
    func getState() -> String {
        return state
    }
}

class Originator {
    private var state: String = ""
    
    func setState(_ state: String) {
        self.state = state
    }
    
    func getState() -> String {
        return state
    }
    
    func saveStateToMemento() -> Memento {
        return Memento(state: state)
    }
    
    func getStateFromMemento(memento: Memento) {
        state = memento.getState()
    }
}

class Caretaker {
    private var mementos: [Memento] = []
    
    func add(memento: Memento) {
        mementos.append(memento)
    }
    
    func get(index: Int) -> Memento? {
        guard index >= 0 && index < mementos.count else {
            return nil
        }
        return mementos[index]
    }
    
    func getHistoryCount() -> Int {
        return mementos.count
    }
}

