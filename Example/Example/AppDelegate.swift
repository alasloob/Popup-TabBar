//
//  AppDelegate.swift
//  Example
//
//  Created by Youssef Eid on 11/06/1440 AH.
//  Copyright © 1440 Youssef Eid. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        //
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        // create UITabBarContoller
        let tbController = YSTabBarController()
        
        let v1 = ViewController()
        let v2 = ViewController()
        let v3 = ViewController()
        let v4 = ViewController()
        let v5 = ViewController()
        let v6 = ViewController()
        let v7 = ViewController()
        let v8 = ViewController()
        
        v1.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.contacts, tag: 1)
        v2.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.bookmarks, tag: 2)
        v3.tabBarItem = UITabBarItem(title: "First", image: #imageLiteral(resourceName: "007"), tag: 3)
        v4.tabBarItem = UITabBarItem(title: "Second", image: #imageLiteral(resourceName: "002"), tag: 4)
        v5.tabBarItem = UITabBarItem(title: "Third", image: #imageLiteral(resourceName: "005"), tag: 5)
        v6.tabBarItem = UITabBarItem(title: "Fourth", image: #imageLiteral(resourceName: "004"), tag: 6)
        v7.tabBarItem = UITabBarItem(title: "Fifth", image: #imageLiteral(resourceName: "006"), tag: 7)
        v8.tabBarItem = UITabBarItem(title: "Sixth", image: #imageLiteral(resourceName: "001"), tag: 8)
        
        v1.view.backgroundColor = .white
        v2.view.backgroundColor = .green
        v3.view.backgroundColor = .yellow
        v4.view.backgroundColor = .purple
        v5.view.backgroundColor = .gray
        v6.view.backgroundColor = .orange
        v7.view.backgroundColor = .darkGray
        v8.view.backgroundColor = .cyan
        
        let nvbar = UINavigationController(rootViewController: v5)
        v5.title = "Third"
        tbController.popCountTabBar = 2
        tbController.viewControllers = [v1,v2,v3,v4,nvbar,v6,v7,v8]
        
        self.window?.rootViewController = tbController
        self.window?.makeKeyAndVisible() // show window
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

