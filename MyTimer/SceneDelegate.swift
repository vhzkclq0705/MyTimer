//
//  SceneDelegate.swift
//  MyTimer
//
//  Created by 권오준 on 2022/05/29.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        //window?.backgroundColor = .white
        window?.rootViewController = SplashVC()
        window?.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.window?.rootViewController = TimerListVC()
        }
        
        
    }


}

