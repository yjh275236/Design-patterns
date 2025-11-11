//
//  MediatorPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 中介者模式
// 核心角色：Mediator 负责转发消息，Colleague 之间不直接通信
// 新手提示：留意“核心实现”注释了解消息如何经由中介者转发，其他代码是示例同事

// 中介者协议，定义中介者的接口
protocol Mediator {
    // 核心实现：接收发送者事件并转发
    func notify(sender: Colleague, event: String) -> String?
}

// 同事协议，定义同事类的接口，使用AnyObject限制为类类型
protocol Colleague: AnyObject {
    // 中介者引用（可选）
    var mediator: Mediator? { get set }
    // 核心实现：将事件发送给中介者
    func send(event: String) -> String?
    // 接收消息的方法
    func receive(message: String)
}

// 具体中介者类，实现Mediator协议，管理所有同事对象之间的通信
class ConcreteMediator: Mediator {
    // 私有属性：存储所有同事对象的数组
    private var colleagues: [Colleague] = []
    
    // 添加同事的方法
    func addColleague(_ colleague: Colleague) {
        // 将同事添加到数组中
        colleagues.append(colleague)
        // 设置同事的中介者引用为自己
        colleague.mediator = self
    }
    
    // 实现notify方法，处理同事之间的通信
    func notify(sender: Colleague, event: String) -> String? {
        // 初始化结果字符串
        var result = ""
        // 遍历所有同事
        for colleague in colleagues {
            // 如果不是发送者本身，则向其发送消息
            if colleague !== sender {
                // 核心实现：在单一位置控制消息分发
                colleague.receive(message: "收到消息: \(event)")
                // 添加到结果字符串
                result += "消息已发送给其他同事\n"
            }
        }
        // 如果结果不为空，返回结果；否则返回nil
        return result.isEmpty ? nil : result
    }
}

// 具体同事类，实现Colleague协议
class ConcreteColleague: Colleague {
    // 中介者引用（可选）
    var mediator: Mediator?
    // 同事的名称
    let name: String
    
    // 初始化方法，设置同事名称
    init(name: String) {
        // 保存同事名称
        self.name = name
    }
    
    // 实现send方法，发送事件
    func send(event: String) -> String? {
        // 通过中介者发送事件
        return mediator?.notify(sender: self, event: event)
    }
    
    // 实现receive方法，接收消息
    func receive(message: String) {
        // 打印接收到的消息，包含同事名称
        print("\(name) \(message)")
    }
}

// 使用示例（通过中介者协调多个同事对象）：
// let mediator = ConcreteMediator()
// let alice = ConcreteColleague(name: "Alice")
// let bob = ConcreteColleague(name: "Bob")
// mediator.addColleague(alice)
// mediator.addColleague(bob)
// alice.send(event: "请求支援")                    // 核心：消息经由中介者转发给其他同事

