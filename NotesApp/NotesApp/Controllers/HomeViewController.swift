//
//  HomeViewController.swift
//  NotesApp
//
//  Created by Obed Garcia on 5/2/21.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func didTapNavMenu()
}

class HomeViewController: UIViewController {
    weak var navDelegate: HomeViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        UINavigationBar.appearance().tintColor = UIColor(red: 241/255, green: 100/255, blue: 100/255, alpha: 1.0)
        let navMenuButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didTapNavMenu))
        navigationItem.leftBarButtonItem = navMenuButton
    }

    @objc func didTapNavMenu() {
        navDelegate?.didTapNavMenu()
    }
}
