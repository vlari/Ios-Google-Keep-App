//
//  TagViewController.swift
//  NotesApp
//
//  Created by Obed Garcia on 5/1/21.
//

import UIKit
import CoreData

protocol TagListViewDelegate: AnyObject {
    func didUpdateTagList(tagList: [Tag])
}

class TagListViewController: UIViewController {
    var managedContext: NSManagedObjectContext!
    var tagTableView = UITableView()
    private var dataSource: TagDataSource!
    var tags = [Tag]()
    
    weak var tagListDelegate: TagListViewDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTableView()
        configureDataSource()
        applySnapshot()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tagListDelegate?.didUpdateTagList(tagList: tags)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            tagTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tagTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tagTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tagTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configure() {
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddTag))
    }
    
    func configureTableView() {
        view.addSubview(tagTableView)
        tagTableView.delegate = self
        tagTableView.translatesAutoresizingMaskIntoConstraints = false
        tagTableView.rowHeight = 100
        tagTableView.register(UITableViewCell.self, forCellReuseIdentifier: "tagCell")
    }
    
    func configureDataSource() {
        dataSource = TagDataSource(tableView: tagTableView) { (tableView: UITableView, indexPath: IndexPath, tag: Tag) ->
            UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath)
            
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.lineBreakMode = .byTruncatingTail
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = tag.name
            
            return cell
        }
    }
    
    private func applySnapshot() {
        var currentSnapshot = NSDiffableDataSourceSnapshot<TagSection, Tag>()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(tags)
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
    
    func showAlert(tagName: String = "") {
        let alert = UIAlertController(
            title: "Title here",
            message: "message",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { textField in
            textField.text = tagName
        }
        let action = UIAlertAction(
            title: "Ok",
            style: .default,
            handler: { [weak self] action in
                guard let tag = alert.textFields?.first?.text else { return }
                guard let self = self else { return }
                
                if tagName.isEmpty {
                    self.tags.append(Tag(name: tag.trimmingCharacters(in: .whitespacesAndNewlines)))
                } else if self.canAddTag(name: tag) {
                    if let index = self.tags.firstIndex(where: { $0.name == tagName}) {
                        self.tags[index].name = tag
                    }
                } else {
                    return
                }
                
//                self.applySnapshot()
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        )
        
        alert.addAction(cancelAction)
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
    
    func canAddTag(name: String) -> Bool {
        var isDuplicated = true

        if let _ = tags.first(where: { $0.name == name }) {
            isDuplicated = false
        }
        
        return isDuplicated
    }
    
    @objc func didTapAddTag() {
        showAlert()
    }
    
    @objc func didTapClose() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - TableView Delegate
extension TagListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (contextualAction, view, completionHandler) in
            guard let self = self else { return }
            guard let tag = self.dataSource?.itemIdentifier(for: indexPath) else { return }

            var currentSnapshot = self.dataSource.snapshot()
            currentSnapshot.deleteItems([tag])
            self.dataSource.apply(currentSnapshot)
            self.tags =  currentSnapshot.itemIdentifiers
            
            completionHandler(true)
        }

        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = true
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tag = dataSource.itemIdentifier(for: indexPath) else { return }
        showAlert(tagName: tag.name)
    }
    
}

// MARK: - Data Source
class TagDataSource: UITableViewDiffableDataSource<TagSection, Tag> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

enum TagSection {
    case main
}

var mockDatas: [Tag] = [
    Tag(name: "James"),
    Tag(name: "Alexa")
]
