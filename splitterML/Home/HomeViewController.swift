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
    private let bottomBar = UIStackView()
    
    private let isRootViewController: Bool
    private let viewModel: HomeViewModel
    
    required init(isRootViewController: Bool = false, viewModel: HomeViewModel = HomeViewModel()) {
        self.isRootViewController = isRootViewController
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
        viewModel.setNavBarTitle = setNavBarTitle
    }
    
    private func popHomeViewController() {
        navigationController?.popViewController(animated: true)
        if isRootViewController {
            navigationController?.pushViewController(WelcomeViewController(), animated: true)
        }
    }
    
    @objc private func logOut() {
        viewModel.logOut()
    }
    
    private func showAlert(title: String, message: String) {
        let alertView = AlertViewFactory.createAlertView(title: title,
                                                         message: message)
        
        present(alertView, animated: true, completion: nil)
        
    }
    
    private func setNavBarTitle(_ userName: String) {
        title = userName
    }
}

extension HomeViewController: Subviewable {
    func setupSubviews() {
                
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.barTintColor = Palette.mainGreen
        
        view.backgroundColor = .white
        view.accessibilityIdentifier = String.AccessID.homeVC
        
        logoutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        logoutButton.setTitle(String.Localized.HomeVC.logout, for: .normal)
        logoutButton.titleLabel?.font = UIFont(name: Font.printStyle, size: Font.Size.buttonTitle)
        logoutButton.backgroundColor = .clear
        
        bottomBar.addBackgroundColor(Palette.mainGreen)
        bottomBar.axis = .horizontal
        bottomBar.distribution = .equalSpacing
        bottomBar.spacing = Layout.spacer
    }
    
    func setupHierarchy() {
        view.addSubview(bottomBar)
        bottomBar.addArrangedSubview(logoutButton)
    }
    
    func setupAutoLayout() {
        bottomBar.pinBottom(to: view, anchor: .bottom)
        bottomBar.pinLeft(to: view, anchor: .left)
        bottomBar.pinRight(to: view, anchor: .right)
        bottomBar.addHeightConstraint(with: Layout.buttonHeight)
    }
}
