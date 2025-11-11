//
//  AdapterPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

// 导入Foundation框架，提供基础功能支持
import Foundation

// MARK: - 适配器模式

// 媒体播放器协议，定义标准的播放接口
protocol MediaPlayer {
    // 播放音频文件的方法，接收音频类型和文件名
    func play(audioType: String, fileName: String)
}

// 音频播放器类，实现MediaPlayer协议，支持mp3格式
class AudioPlayer: MediaPlayer {
    // 实现play方法，播放音频文件
    func play(audioType: String, fileName: String) {
        // 检查是否为mp3格式
        if audioType == "mp3" {
            // 如果是mp3，直接播放
            print("播放 mp3 文件: \(fileName)")
        } else {
            // 如果不是mp3，提示不支持
            print("不支持的音频格式: \(audioType)")
        }
    }
}

// 高级媒体播放器协议，定义支持vlc和mp4格式的接口
protocol AdvancedMediaPlayer {
    // 播放VLC格式文件的方法
    func playVlc(fileName: String)
    // 播放MP4格式文件的方法
    func playMp4(fileName: String)
}

// VLC播放器类，实现AdvancedMediaPlayer协议
class VlcPlayer: AdvancedMediaPlayer {
    // 实现playVlc方法，播放VLC格式文件
    func playVlc(fileName: String) {
        // 打印播放VLC文件的信息
        print("播放 VLC 文件: \(fileName)")
    }
    
    // 实现playMp4方法，但不支持MP4格式
    func playMp4(fileName: String) {
        // 不支持
    }
}

// MP4播放器类，实现AdvancedMediaPlayer协议
class Mp4Player: AdvancedMediaPlayer {
    // 实现playVlc方法，但不支持VLC格式
    func playVlc(fileName: String) {
        // 不支持
    }
    
    // 实现playMp4方法，播放MP4格式文件
    func playMp4(fileName: String) {
        // 打印播放MP4文件的信息
        print("播放 MP4 文件: \(fileName)")
    }
}

// 媒体适配器类，实现MediaPlayer协议，将AdvancedMediaPlayer接口适配到MediaPlayer接口
class MediaAdapter: MediaPlayer {
    // 私有属性：持有高级媒体播放器的引用
    private var advancedPlayer: AdvancedMediaPlayer?
    
    // 初始化方法，根据音频类型创建对应的播放器
    init(audioType: String) {
        // 如果是vlc格式，创建VLC播放器
        if audioType == "vlc" {
            advancedPlayer = VlcPlayer()
        } else if audioType == "mp4" {
            // 如果是mp4格式，创建MP4播放器
            advancedPlayer = Mp4Player()
        }
    }
    
    // 实现play方法，适配高级播放器的接口
    func play(audioType: String, fileName: String) {
        // 如果是vlc格式，调用VLC播放器的playVlc方法
        if audioType == "vlc" {
            advancedPlayer?.playVlc(fileName: fileName)
        } else if audioType == "mp4" {
            // 如果是mp4格式，调用MP4播放器的playMp4方法
            advancedPlayer?.playMp4(fileName: fileName)
        }
    }
}

// 增强音频播放器类，继承自AudioPlayer，支持更多格式
class EnhancedAudioPlayer: AudioPlayer {
    // 私有属性：持有媒体适配器的引用
    private var mediaAdapter: MediaAdapter?
    
    // 重写play方法，扩展支持更多格式
    override func play(audioType: String, fileName: String) {
        // 如果是mp3格式，调用父类方法播放
        if audioType == "mp3" {
            super.play(audioType: audioType, fileName: fileName)
        } else if audioType == "vlc" || audioType == "mp4" {
            // 如果是vlc或mp4格式，使用适配器播放
            mediaAdapter = MediaAdapter(audioType: audioType)
            mediaAdapter?.play(audioType: audioType, fileName: fileName)
        } else {
            // 其他格式不支持
            print("不支持的音频格式: \(audioType)")
        }
    }
}

