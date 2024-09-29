//
//  SceneDelegate.swift
//  SocialArt
//
//  Created by Ayca Akman on 14.10.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBar = TabBarViewController()
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene 
    }
}
