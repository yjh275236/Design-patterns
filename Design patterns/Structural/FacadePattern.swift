//
//  FacadePattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 外观模式

class CPU {
    func freeze() {
        print("CPU 冻结")
    }
    
    func jump(position: Int) {
        print("CPU 跳转到位置: \(position)")
    }
    
    func execute() {
        print("CPU 执行")
    }
}

class Memory {
    func load(position: Int, data: String) {
        print("内存加载数据到位置 \(position): \(data)")
    }
}

class HardDrive {
    func read(lba: Int, size: Int) -> String {
        let data = "从硬盘 LBA \(lba) 读取 \(size) 字节的数据"
        print(data)
        return data
    }
}

class ComputerFacade {
    private let cpu: CPU
    private let memory: Memory
    private let hardDrive: HardDrive
    
    init() {
        self.cpu = CPU()
        self.memory = Memory()
        self.hardDrive = HardDrive()
    }
    
    func start() {
        print("=== 启动计算机 ===")
        cpu.freeze()
        let data = hardDrive.read(lba: 0, size: 1024)
        memory.load(position: 0, data: data)
        cpu.jump(position: 0)
        cpu.execute()
        print("✅ 计算机启动完成\n")
    }
}

