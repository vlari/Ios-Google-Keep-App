//
//  MainViewController.swift
//  NotesApp
//
//  Created by Obed Garcia on 5/2/21.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    let navBarVC = NavBarViewController()
    let noteListVC = NoteListViewController()
    let homeVC = HomeViewController()
    lazy var tagVC = TagListViewController()
    var navVC: UINavigationController?
    var currentVC: UIViewController?
    var managedContext: NSManagedObjectContext?
    
    
    
    private var menuState: NavMenuState = .closed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        addChildViews()
    }
    
    private func addChildViews() {
        navBarVC.delegate = self
        add(navBarVC, container: view)
        
        homeVC.navDelegate = self
        let navVC = UINavigationController(rootViewController: homeVC)
        add(navVC, container: view)
        self.navVC = navVC
        
        setDisplayedView(menuItem: .noteList)
    }
    
    enum NavMenuState {
        case opened
        case closed
    }
    
    func setDisplayedView(menuItem: NavBarViewController.NavMenuItems) {
        switch menuItem {
        case .noteList:
            addBaseView(child: noteListVC)
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddNote))
            homeVC.navigationItem.rightBarButtonItem = addButton
        case .tags:
            tagVC.managedContext = self.managedContext
            addBaseView(child: tagVC)
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddTag))
            homeVC.navigationItem.rightBarButtonItem = addButton
        }
    }
    
    @objc func didTapAddNote() {
        let noteDetailVC = NoteDetailViewController()
        homeVC.navigationController?.pushViewController(noteDetailVC, animated: true)
    }
    
    @objc func didTapAddTag() {
        let addTagVC = AddTagViewController()
        addTagVC.manageContext = self.managedContext
        let navController = UINavigationController(rootViewController: addTagVC)
        present(navController, animated: true)
    }
    
}

// MARK: - Home Delegate
extension MainViewController: HomeViewControllerDelegate {
    func didTapNavMenu() {
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?) {
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = self.homeVC.view.frame.size.width - 200
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                }
            }

        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
}

// MARK: - Navbar Delegate
extension MainViewController: NavBarViewControllerDelegate {
    func didSelectNavItem(menuItem: NavBarViewController.NavMenuItems) {
        toggleMenu(completion: nil)
        setDisplayedView(menuItem: menuItem)
    }
    
    func addBaseView(child: UIViewController) {
        homeVC.navigationItem.rightBarButtonItems?.removeAll()
        if let currentViewController = currentVC {
            currentViewController.view.removeFromSuperview()
            currentViewController.didMove(toParent: nil)
        }
        
        homeVC.addChild(child)
        homeVC.view.addSubview(child.view)
        child.view.frame = view.frame
        child.didMove(toParent: homeVC)
        homeVC.title = child.title
        currentVC = child
    }
}
