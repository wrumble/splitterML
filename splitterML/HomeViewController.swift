//
//  HomeViewController.swift
//  splitterML
//
//  Created by Wayne Rumble on 14/07/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let logoutButton = UIButton()
    
    private let viewModel: HomeViewModel
    
    required init(viewModel: HomeViewModel) {
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
    
    @objc private func logOut() {
        viewModel.logOut()
    }
    
    private func showAlert(title: String, message: String) {
        let alertView = AlertViewFactory.createAlertView(title: title,
                                                         message: message)
        
        present(alertView, animated: true, completion: nil)
        
    }
}

extension HomeViewController: Subviewable {
    func setupSubviews() {
        navigationItem.setHidesBackButton(true, animated: true)
        
        view.backgroundColor = .white
        view.accessibilityIdentifier = String.AccessID.homeVC
        
        logoutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        logoutButton.setTitle(String.Localized.HomeVC.logout, for: .normal)
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
