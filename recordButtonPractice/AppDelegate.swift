//
//  AppDelegate.swift
//  recordButtonPractice
//
//  Created by Lance Samaria on 6/27/20.
//  Copyright © 2020 Lance Samaria. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let vc = ViewController()
        let navVC = UINavigationController(rootViewController: vc)
        window?.rootViewController = navVC
        
        
        return true
    }
}

