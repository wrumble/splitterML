//
//  UpdateProfileViewController.swift
//  splitterML
//
//  Created by Wayne Rumble on 25/10/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import Foundation

import UIKit

class UpdateProfileViewController: UIViewController {
    
    private let logoutButton = UIButton()
    
    private let viewModel: UpdateProfileViewModel
    
    required init(viewModel: UpdateProfileViewModel = UpdateProfileViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        bindViewModel()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViewModel() {
        viewModel.showAlert = showAlert
        viewModel.popHomeViewController = popHomeViewController
    }
    
    private func popHomeViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func update() {
        let profile = UserProfile()
        viewModel.updateProfile(with: profile)
    }
    
    private func showAlert(title: String, message: String) {
        let alertView = AlertViewFactory.createAlertView(title: title,
                                                         message: message)
        
        present(alertView, animated: true, completion: nil)
        
    }
}

extension UpdateProfileViewController: Subviewable {
    func setupSubviews() {
        navigationItem.setHidesBackButton(true, animated: true)
        
        view.backgroundColor = .white
        view.accessibilityIdentifier = String.AccessID.homeVC
        
        logoutButton.addTarget(self, action: #selector(update), for: .touchUpInside)
        logoutButton.setTitle("Save", for: .normal)
        logoutButton.backgroundColor = .black
    }
    
    func setupHierarchy() {
        view.addSubview(logoutButton)
    }
    
    func setupAutoLayout() {
        logoutButton.pinBottom(to: view, anchor: .bottom, constant: -Layout.spacer)
        logoutButton.pinLeft(to: view, anchor: .left, constant: Layout.spacer)
        logoutButton.pinRight(to: view, anchor: .right, constant: -Layout.spacer)
        logoutButton.addHeightConstraint(with: Layout.buttonHeight)
    }
}
