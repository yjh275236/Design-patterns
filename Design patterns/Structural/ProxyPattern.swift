//
//  ProxyPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 代理模式
// 核心角色：ImageProxy 作为代理控制 RealImage 的创建与访问，实现延迟加载
// 新手提示：标记为“核心实现”的代码展现代理模式的关键，其余逻辑用于输出演示

// 定义图片接口，所有图片类都必须实现display方法
protocol Image {
    // 显示图片的方法
    func display()
}

// 真实图片类，实现Image接口，代表需要被代理的真实对象
class RealImage: Image {
    // 私有属性：存储图片文件名
    private let filename: String
    
    // 演示逻辑：创建真实图片对象时自动从磁盘加载
    init(filename: String) {
        // 保存文件名
        self.filename = filename
        // 立即从磁盘加载图片（模拟耗时操作）
        loadFromDisk()
    }
    
    // 私有方法：从磁盘加载图片（模拟耗时操作）
    private func loadFromDisk() {
        // 打印加载信息
        print("从磁盘加载图片: \(filename)")
    }
    
    // 实现display方法，显示图片
    func display() {
        // 打印显示信息
        print("显示图片: \(filename)")
    }
}

// 图片代理类，实现Image接口，控制对真实图片对象的访问
class ImageProxy: Image {
    // 私有属性：存储图片文件名
    private let filename: String
    // 可选的真实图片对象引用，延迟加载时才创建
    private var realImage: RealImage?
    
    // 初始化方法，创建代理对象时不会立即加载图片
    init(filename: String) {
        // 保存文件名，但不立即创建真实对象
        self.filename = filename
    }
    
    // 实现display方法，控制对真实对象的访问
    func display() {
        // 检查真实图片对象是否已创建
        if realImage == nil {
            // 核心实现：延迟创建真实对象
            realImage = RealImage(filename: filename)
        }
        // 调用真实图片对象的display方法
        realImage?.display()
    }
}

// 使用示例（在需要展示图片时调用代理而非直接创建真实对象）：
// let image: Image = ImageProxy(filename: "地图.png")   // 核心：通过代理持有真实对象
// image.display()                                      // 第一次调用会触发 RealImage 加载
// image.display()                                      // 后续调用复用已加载的图片

