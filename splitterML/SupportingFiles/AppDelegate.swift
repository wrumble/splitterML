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
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        setRootViewController()
        
        let titleAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,
                               .font: Font.fancyStyle.size(.navBarTitleSize)]
        
        UINavigationBar.appearance().barTintColor = Palette.mainGreen
        UINavigationBar.appearance().titleTextAttributes = titleAttributes
        
        UITextField.appearance().font = Font.printStyle.size(.textFieldPlaceHolderSize)
        
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        
        let facebookHandled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        let googleOptions = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let googleHandled = GIDSignIn.sharedInstance().handle(url,
                                                              sourceApplication: googleOptions,
                                                              annotation: [:])
        
        return facebookHandled || googleHandled == true ? true : false
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
