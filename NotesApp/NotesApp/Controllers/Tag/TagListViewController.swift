//
//  TagViewController.swift
//  NotesApp
//
//  Created by Obed Garcia on 5/1/21.
//

import UIKit
import CoreData

class TagListViewController: UIViewController {
    var managedContext: NSManagedObjectContext!
    private var tagTableView = UITableView()
    private var dataSource: TagDataSource!
    
    lazy var fetchedResultsController: NSFetchedResultsController<TagEntity> = {
        let fetchRequest: NSFetchRequest<TagEntity> = TagEntity.fetchRequest()
        let nameSort = NSSortDescriptor(key: #keyPath(TagEntity.name), ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTableView()
        configureDataSource()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.performWithoutAnimation {
            do {
                try fetchedResultsController.performFetch()
            } catch let error as NSError {
                print("error \(error)")
            }
        }
    }
    
    func configure() {
        view.backgroundColor = .systemBackground
        title = "Tags"
    }
    
    func configureTableView() {
        view.addSubview(tagTableView)
        tagTableView.delegate = self
        tagTableView.translatesAutoresizingMaskIntoConstraints = false
        tagTableView.rowHeight = 100
        tagTableView.register(TagTableViewCell.self, forCellReuseIdentifier: TagTableViewCell.identifier)
    }
    
    func configureDataSource() {
        dataSource = TagDataSource(tableView: tagTableView) { (tableView: UITableView, indexPath: IndexPath, tag: TagEntity) ->
            UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TagTableViewCell.identifier, for: indexPath) as? TagTableViewCell
            else {
                return TagTableViewCell()
            }
            cell.set(tag: tag.name ?? "")
            return cell
        }
    }
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            tagTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tagTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tagTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tagTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func applySnapshot() {
        var currentSnapshot = NSDiffableDataSourceSnapshot<TagSection, TagEntity>()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
        dataSource?.apply(currentSnapshot)
    }

    private func delete(tag item: NSManagedObject, completion: @escaping (Result<Bool, Error>) -> ()) {
        do {
            managedContext.delete(item)
            try managedContext.save()
            completion(.success(true))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }    
}

// MARK: - TableView Delegate
extension TagListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, completionHandler) in
            guard let tag = self.dataSource?.itemIdentifier(for: indexPath) else { return }
            
            self.delete(tag: tag) { (result) in
                switch result {
                    case .success(let isTagDeleted):
                        if isTagDeleted {
                            print("deleted")
                            self.applySnapshot()
                            completionHandler(true)
                        }
                    case .failure(let error):
                        print("error \(error)")
                }
            }
        }

        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = true
        return swipeConfiguration
    }
}

// MARK: - NSFetchedResultsController Delegate
extension TagListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        applySnapshot()
    }
}

class TagDataSource: UITableViewDiffableDataSource<TagSection, TagEntity> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

enum TagSection {
    case main
}
