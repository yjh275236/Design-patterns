//
//  PatternMainViewController.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

struct DesignPattern {
    let name: String
    let category: String
    let description: String
    let viewControllerType: UIViewController.Type
}

class PatternMainViewController: UITableViewController {
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let patterns: [DesignPattern] = [
        // 创建型模式
        DesignPattern(name: "单例模式 (Singleton)", category: "创建型", description: "确保一个类只有一个实例，并提供全局访问点", viewControllerType: SingletonDemoViewController.self),
        DesignPattern(name: "工厂方法模式 (Factory Method)", category: "创建型", description: "定义一个创建对象的接口，让子类决定实例化哪一个类", viewControllerType: FactoryMethodDemoViewController.self),
        DesignPattern(name: "抽象工厂模式 (Abstract Factory)", category: "创建型", description: "提供一个接口，用于创建相关或依赖对象的家族", viewControllerType: AbstractFactoryDemoViewController.self),
        DesignPattern(name: "建造者模式 (Builder)", category: "创建型", description: "将一个复杂对象的构建与其表示分离，使同样的构建过程可以创建不同的表示", viewControllerType: BuilderDemoViewController.self),
        DesignPattern(name: "原型模式 (Prototype)", category: "创建型", description: "通过复制现有实例来创建新实例", viewControllerType: PrototypeDemoViewController.self),
        
        // 结构型模式
        DesignPattern(name: "适配器模式 (Adapter)", category: "结构型", description: "将一个类的接口转换成客户希望的另一个接口", viewControllerType: AdapterDemoViewController.self),
        DesignPattern(name: "桥接模式 (Bridge)", category: "结构型", description: "将抽象部分与实现部分分离，使它们可以独立变化", viewControllerType: BridgeDemoViewController.self),
        DesignPattern(name: "组合模式 (Composite)", category: "结构型", description: "将对象组合成树形结构以表示部分-整体的层次结构", viewControllerType: CompositeDemoViewController.self),
        DesignPattern(name: "装饰模式 (Decorator)", category: "结构型", description: "动态地给一个对象添加一些额外的职责", viewControllerType: DecoratorDemoViewController.self),
        DesignPattern(name: "外观模式 (Facade)", category: "结构型", description: "为子系统中的一组接口提供一个统一的接口", viewControllerType: FacadeDemoViewController.self),
        DesignPattern(name: "享元模式 (Flyweight)", category: "结构型", description: "运用共享技术有效地支持大量细粒度的对象", viewControllerType: FlyweightDemoViewController.self),
        DesignPattern(name: "代理模式 (Proxy)", category: "结构型", description: "为其他对象提供一种代理以控制对这个对象的访问", viewControllerType: ProxyDemoViewController.self),
        
        // 行为型模式
        DesignPattern(name: "责任链模式 (Chain of Responsibility)", category: "行为型", description: "为解除请求的发送者和接收者之间耦合，而使多个对象都有机会处理这个请求", viewControllerType: ChainOfResponsibilityDemoViewController.self),
        DesignPattern(name: "命令模式 (Command)", category: "行为型", description: "将一个请求封装成一个对象，从而使您可以用不同的请求对客户进行参数化", viewControllerType: CommandDemoViewController.self),
        DesignPattern(name: "解释器模式 (Interpreter)", category: "行为型", description: "给定一个语言，定义它的文法的一种表示，并定义一个解释器", viewControllerType: InterpreterDemoViewController.self),
        DesignPattern(name: "迭代器模式 (Iterator)", category: "行为型", description: "提供一种方法顺序访问一个聚合对象中各个元素", viewControllerType: IteratorDemoViewController.self),
        DesignPattern(name: "中介者模式 (Mediator)", category: "行为型", description: "用一个中介对象来封装一系列的对象交互", viewControllerType: MediatorDemoViewController.self),
        DesignPattern(name: "备忘录模式 (Memento)", category: "行为型", description: "在不破坏封装性的前提下，捕获一个对象的内部状态，并在该对象之外保存这个状态", viewControllerType: MementoDemoViewController.self),
        DesignPattern(name: "观察者模式 (Observer)", category: "行为型", description: "定义对象间一对多的依赖关系，当一个对象的状态发生改变时，所有依赖于它的对象都得到通知", viewControllerType: ObserverDemoViewController.self),
        DesignPattern(name: "状态模式 (State)", category: "行为型", description: "允许一个对象在其内部状态改变时改变它的行为", viewControllerType: StateDemoViewController.self),
        DesignPattern(name: "策略模式 (Strategy)", category: "行为型", description: "定义一系列的算法，把它们一个个封装起来，并且使它们可相互替换", viewControllerType: StrategyDemoViewController.self),
        DesignPattern(name: "模板方法模式 (Template Method)", category: "行为型", description: "定义一个操作中的算法的骨架，而将一些步骤延迟到子类中", viewControllerType: TemplateMethodDemoViewController.self),
        DesignPattern(name: "访问者模式 (Visitor)", category: "行为型", description: "表示一个作用于某对象结构中的各元素的操作", viewControllerType: VisitorDemoViewController.self),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "设计模式学习"
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .singleLine
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 5  // 创建型
        case 1: return 7  // 结构型
        case 2: return 11 // 行为型
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "创建型模式 (Creational Patterns)"
        case 1: return "结构型模式 (Structural Patterns)"
        case 2: return "行为型模式 (Behavioral Patterns)"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let index = getPatternIndex(for: indexPath)
        let pattern = patterns[index]
        
        cell.textLabel?.text = pattern.name
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = pattern.description
        cell.detailTextLabel?.numberOfLines = 2
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .systemBackground
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let index = getPatternIndex(for: indexPath)
        let pattern = patterns[index]
        let viewController = pattern.viewControllerType.init()
        viewController.title = pattern.name
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func getPatternIndex(for indexPath: IndexPath) -> Int {
        switch indexPath.section {
        case 0: return indexPath.row
        case 1: return 5 + indexPath.row
        case 2: return 12 + indexPath.row
        default: return 0
        }
    }
}

