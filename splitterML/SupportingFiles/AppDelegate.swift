//
//  AppDelegate.swift
//  splitterML
//
//  Created by Wayne Rumble on 11/07/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        setRootViewController()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        return handled
    }
    
    private func setRootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if Auth.auth().currentUser != nil {
            let homeViewModel = HomeViewModel()
            let homeViewController = HomeViewController(viewModel: homeViewModel)
            window?.rootViewController = UINavigationController(rootViewController: homeViewController)
        } else {
            let welcomeViewModel = WelcomeViewModel()
            let welcomeViewController = WelcomeViewController(viewModel: welcomeViewModel)
            window?.rootViewController = UINavigationController(rootViewController: welcomeViewController)
        }
    }
}

