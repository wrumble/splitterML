//
//  AppDelegate.swift
//  splitterML
//
//  Created by Wayne Rumble on 11/07/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        setRootViewController()
        
        let titleAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,
                               .font: UIFont(name: Font.fancyStyle, size: Font.Size.navBarTitle) as Any] as [NSAttributedStringKey : Any]
        
        UINavigationBar.appearance().barTintColor = Palette.mainGreen
        UINavigationBar.appearance().titleTextAttributes = titleAttributes
        application.statusBarStyle = .lightContent
        
        UITextField.appearance().font = UIFont(name: Font.printStyle, size: Font.Size.textFieldPlaceHolder)
        
        return true
    }
    private func setRootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if Auth.auth().currentUser != nil {
            let homeViewController = HomeViewController(isRootViewController: true)
            window?.rootViewController = UINavigationController(rootViewController: homeViewController)
        } else {
            let welcomeViewController = WelcomeViewController()
            window?.rootViewController = UINavigationController(rootViewController: welcomeViewController)
        }
    }
}
