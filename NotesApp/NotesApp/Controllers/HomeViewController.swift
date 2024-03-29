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
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(hex: "#FFC0C7")!]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(hex: "#FFC0C7")!]
        let navMenuButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didTapNavMenu))
        navigationItem.leftBarButtonItem = navMenuButton
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    @objc func didTapNavMenu() {
        navDelegate?.didTapNavMenu()
    }
}
