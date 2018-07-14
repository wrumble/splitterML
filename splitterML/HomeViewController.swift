//
//  HomeViewController.swift
//  splitterML
//
//  Created by Wayne Rumble on 14/07/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    private let logoutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc func logOut() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                navigationController?.popViewController(animated: true)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}

extension HomeViewController: Subviewable {
    func setupSubviews() {
        navigationItem.setHidesBackButton(true, animated: true)
        
        view.backgroundColor = .white
        view.accessibilityIdentifier = "HomeViewController"
        
        logoutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = .black
    }
    
    func setupHierarchy() {
        view.addSubview(logoutButton)
    }
    
    func setupAutoLayout() {
        logoutButton.pinBottom(to: view, anchor: .bottom, constant: -Layout.spacer)
        logoutButton.pinLeft(to: view, anchor: .left, constant: Layout.spacer)
        logoutButton.pinRight(to: view, anchor: .right, constant: -Layout.spacer)
        logoutButton.addHeightConstraint(with: 44)
    }
}
