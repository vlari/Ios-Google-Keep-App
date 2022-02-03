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
    lazy var settingsVC = SettingsViewController()
    var navVC: UINavigationController?
    var currentVC: UIViewController?
    var managedContext: NSManagedObjectContext?
    lazy var fetchedResultsController: NSFetchedResultsController<NoteEntity> = getFetchResultController()
    
    // MARK: - Search controller
    let searchController: UISearchController = {
        let view = UISearchController(searchResultsController: nil)
        view.searchBar.placeholder = "Search character"
        view.searchBar.searchBarStyle = .minimal
        view.definesPresentationContext = true
        view.obscuresBackgroundDuringPresentation = false
        return view
    }()
    var searchedText: String = ""
    private var menuState: NavMenuState = .closed
    
    private func getFetchResultController() -> NSFetchedResultsController<NoteEntity> {
        guard let managedContext = managedContext else {
            return NSFetchedResultsController<NoteEntity>()
        }

        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        let nameSort = NSSortDescriptor(key: #keyPath(NoteEntity.createdAt), ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        fetchRequest.fetchBatchSize = 20

        if !searchedText.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", searchedText)
        }

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)

        fetchedResultsController.delegate = self
        return fetchedResultsController
    }
    
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
    
    func setDisplayedView(menuItem: NavBarViewController.NavMenuItem) {
        switch menuItem {
        case .noteList:
            noteListVC.managedContext = self.managedContext
            addBaseView(child: noteListVC)
            noteListVC.noteListDelegate = self
            homeVC.title = "Quick Notes"
            
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddNote))
            homeVC.navigationItem.rightBarButtonItem = addButton
            
            configureSearchController()
        case .settings:
            addBaseView(child: settingsVC)
            homeVC.title = "Settings"
            homeVC.navigationItem.searchController = nil
        }
        
        homeVC.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self

        homeVC.navigationItem.searchController = searchController
        homeVC.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func fetchNotes() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("error \(error)")
        }
    }
    
    @objc func didTapAddNote() {
        let noteDetailVC = NoteDetailViewController()
        noteDetailVC.managedContext = self.managedContext
        homeVC.navigationController?.pushViewController(noteDetailVC, animated: true)
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


// MARK: - Note List Delegate
extension MainViewController: NoteListViewDelegate {
    func getNotes() {
        self.fetchNotes()
    }
}

// MARK: - Navbar Delegate
extension MainViewController: NavBarViewControllerDelegate {
    func didSelectNavItem(menuItem: NavBarViewController.NavMenuItem) {
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


// MARK: - SearchBar Delegate
extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text,
              !searchText.isEmpty else {
            return
        }
        searchedText = searchText
        fetchedResultsController = getFetchResultController()
        fetchNotes()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchNotes()
    }
}

// MARK: - NSFetchedResultsController Delegate
extension MainViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        guard let dataSource = noteListVC.noteCollectionView.dataSource as? UICollectionViewDiffableDataSource<NoteSection, NSManagedObjectID> else {
            return
        }
        
        var snapshot = snapshot as NSDiffableDataSourceSnapshot<NoteSection, NSManagedObjectID>
        let currentSnapshot = dataSource.snapshot() as NSDiffableDataSourceSnapshot<NoteSection, NSManagedObjectID>

        let reloadIdentifiers: [NSManagedObjectID] = snapshot.itemIdentifiers.compactMap { itemIdentifier in
            guard let currentIndex = currentSnapshot.indexOfItem(itemIdentifier), let index = snapshot.indexOfItem(itemIdentifier), index == currentIndex else {
                return nil
            }
            guard let existingObject = try? controller.managedObjectContext.existingObject(with: itemIdentifier), existingObject.isUpdated else { return nil }
            return itemIdentifier
        }
        snapshot.reloadItems(reloadIdentifiers)
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<NoteSection, NSManagedObjectID>, animatingDifferences: true)
    }
}
