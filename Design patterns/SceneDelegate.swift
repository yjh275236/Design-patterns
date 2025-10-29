//
//  SceneDelegate.swift
//  Design patterns
//
//  Created by yjh on 2025/10/29.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // 注意：由于禁用了 Scene 系统，这个方法不会被调用
        // 窗口会在 AppDelegate 中创建
        guard let windowScene = (scene as? UIWindowScene) else {
            print("Error: Failed to get UIWindowScene")
            return
        }
        
        window = UIWindow(windowScene: windowScene)
        let mainViewController = PatternMainViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        window?.rootViewController = navigationController
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

