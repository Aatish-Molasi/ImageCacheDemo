//
//  AppDelegate.swift
//  ImageCacheDemo
//
//  Created by Aatish Molasi on 12/8/18.
//  Copyright © 2018 Aatish Molasi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow()
        let pasteboardViewContorller = PasteboardImagesViewController(pinManager: PinManager.sharedManager)
        let navigationViewController = UINavigationController(rootViewController: pasteboardViewContorller)
        self.window?.rootViewController = navigationViewController
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}

