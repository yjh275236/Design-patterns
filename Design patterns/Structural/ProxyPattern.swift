//
//  ProxyPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 代理模式

protocol Image {
    func display()
}

class RealImage: Image {
    private let filename: String
    
    init(filename: String) {
        self.filename = filename
        loadFromDisk()
    }
    
    private func loadFromDisk() {
        print("从磁盘加载图片: \(filename)")
    }
    
    func display() {
        print("显示图片: \(filename)")
    }
}

class ImageProxy: Image {
    private let filename: String
    private var realImage: RealImage?
    
    init(filename: String) {
        self.filename = filename
    }
    
    func display() {
        if realImage == nil {
            realImage = RealImage(filename: filename)
        }
        realImage?.display()
    }
}

