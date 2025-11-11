//
//  FacadePattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 外观模式

// CPU类，代表计算机的CPU组件
class CPU {
    // 冻结CPU的方法
    func freeze() {
        // 打印CPU冻结信息
        print("CPU 冻结")
    }
    
    // CPU跳转到指定位置的方法
    func jump(position: Int) {
        // 打印CPU跳转信息，显示目标位置
        print("CPU 跳转到位置: \(position)")
    }
    
    // CPU执行指令的方法
    func execute() {
        // 打印CPU执行信息
        print("CPU 执行")
    }
}

// 内存类，代表计算机的内存组件
class Memory {
    // 将数据加载到内存指定位置的方法
    func load(position: Int, data: String) {
        // 打印内存加载信息，显示位置和数据
        print("内存加载数据到位置 \(position): \(data)")
    }
}

// 硬盘类，代表计算机的硬盘组件
class HardDrive {
    // 从硬盘读取数据的方法，接收逻辑块地址和大小
    func read(lba: Int, size: Int) -> String {
        // 构造读取的数据字符串
        let data = "从硬盘 LBA \(lba) 读取 \(size) 字节的数据"
        // 打印读取信息
        print(data)
        // 返回读取的数据
        return data
    }
}

// 计算机外观类，提供简化的接口来操作计算机子系统
class ComputerFacade {
    // 私有属性：CPU实例
    private let cpu: CPU
    // 私有属性：内存实例
    private let memory: Memory
    // 私有属性：硬盘实例
    private let hardDrive: HardDrive
    
    // 初始化方法，创建各个子系统组件
    init() {
        // 创建CPU实例
        self.cpu = CPU()
        // 创建内存实例
        self.memory = Memory()
        // 创建硬盘实例
        self.hardDrive = HardDrive()
    }
    
    // 启动计算机的方法，封装了复杂的启动流程
    func start() {
        // 打印启动开始标记
        print("=== 启动计算机 ===")
        // 第一步：冻结CPU
        cpu.freeze()
        // 第二步：从硬盘读取引导数据
        let data = hardDrive.read(lba: 0, size: 1024)
        // 第三步：将数据加载到内存
        memory.load(position: 0, data: data)
        // 第四步：CPU跳转到引导位置
        cpu.jump(position: 0)
        // 第五步：CPU开始执行
        cpu.execute()
        // 打印启动完成标记
        print("✅ 计算机启动完成\n")
    }
}

