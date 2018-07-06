//
//  AppDelegate.swift
//  DogBreeds
//
//  Created by Keith Hunter on 7/6/18.
//  Copyright © 2018 Keith Hunter. All rights reserved.
//

import UIKit

// In a real app, we would not want to default the comment to an empty string. It's fine for this project though.
func LocalizedString(_ key: String, comment: String = "") -> String {
    return NSLocalizedString(key, comment: comment)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    // MARK: - UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let memCapacity = (1024 * 1024) * 20  // 20 MB
        let diskCapacity = (1024 * 1024) * 100  // 100 MB
        URLCache.shared = URLCache(memoryCapacity: memCapacity, diskCapacity: diskCapacity, diskPath: nil)

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .black
        window.rootViewController = ViewController(service: DogNetworkService())
        window.makeKeyAndVisible()

        return true
    }

}

