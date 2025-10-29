//
//  AppDelegate.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 如果使用 Scene，窗口会在 SceneDelegate 中创建
        // 否则在这里创建（iOS 12 及以下）
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
            
            let mainViewController = PatternMainViewController()
            let navigationController = UINavigationController(rootViewController: mainViewController)
            
            window?.rootViewController = navigationController
            window?.backgroundColor = .systemBackground
            window?.makeKeyAndVisible()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

