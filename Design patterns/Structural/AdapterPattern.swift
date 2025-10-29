//
//  AdapterPattern.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import Foundation

// MARK: - 适配器模式

protocol MediaPlayer {
    func play(audioType: String, fileName: String)
}

class AudioPlayer: MediaPlayer {
    func play(audioType: String, fileName: String) {
        if audioType == "mp3" {
            print("播放 mp3 文件: \(fileName)")
        } else {
            print("不支持的音频格式: \(audioType)")
        }
    }
}

protocol AdvancedMediaPlayer {
    func playVlc(fileName: String)
    func playMp4(fileName: String)
}

class VlcPlayer: AdvancedMediaPlayer {
    func playVlc(fileName: String) {
        print("播放 VLC 文件: \(fileName)")
    }
    
    func playMp4(fileName: String) {
        // 不支持
    }
}

class Mp4Player: AdvancedMediaPlayer {
    func playVlc(fileName: String) {
        // 不支持
    }
    
    func playMp4(fileName: String) {
        print("播放 MP4 文件: \(fileName)")
    }
}

class MediaAdapter: MediaPlayer {
    private var advancedPlayer: AdvancedMediaPlayer?
    
    init(audioType: String) {
        if audioType == "vlc" {
            advancedPlayer = VlcPlayer()
        } else if audioType == "mp4" {
            advancedPlayer = Mp4Player()
        }
    }
    
    func play(audioType: String, fileName: String) {
        if audioType == "vlc" {
            advancedPlayer?.playVlc(fileName: fileName)
        } else if audioType == "mp4" {
            advancedPlayer?.playMp4(fileName: fileName)
        }
    }
}

class EnhancedAudioPlayer: AudioPlayer {
    private var mediaAdapter: MediaAdapter?
    
    override func play(audioType: String, fileName: String) {
        if audioType == "mp3" {
            super.play(audioType: audioType, fileName: fileName)
        } else if audioType == "vlc" || audioType == "mp4" {
            mediaAdapter = MediaAdapter(audioType: audioType)
            mediaAdapter?.play(audioType: audioType, fileName: fileName)
        } else {
            print("不支持的音频格式: \(audioType)")
        }
    }
}

