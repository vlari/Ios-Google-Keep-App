//
//  TagViewController.swift
//  NotesApp
//
//  Created by Obed Garcia on 5/1/21.
//

import UIKit

class TagViewController: UIViewController {
    private var tagTableView = UITableView()
    private var dataSource: TagDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTableView()
        configureDataSource()
        configureLayout()
        dataSource.applySnapshot()
    }
    
    func configure() {
        view.backgroundColor = .systemBackground
    }
    
    func configureTableView() {
        view.addSubview(tagTableView)
        tagTableView.translatesAutoresizingMaskIntoConstraints = false
        tagTableView.rowHeight = 100
        tagTableView.register(TagTableViewCell.self, forCellReuseIdentifier: TagTableViewCell.identifier)
    }
    
    func configureDataSource() {
        dataSource = TagDataSource(tableView: tagTableView) { (tableView: UITableView, indexPath: IndexPath, tag: Tag) ->
            UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TagTableViewCell.identifier, for: indexPath) as? TagTableViewCell
            else {
                return TagTableViewCell()
            }
            
            let selectedTag = tags[indexPath.row]
            cell.set(tag: selectedTag.name)
//            cell.backgroundColor = .systemTeal
            
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
}

// MARK: - Data Source
class TagDataSource: UITableViewDiffableDataSource<TagSection, Tag> {
    func applySnapshot() {
        var currentSnapshot = NSDiffableDataSourceSnapshot<TagSection, Tag>()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(tags)
        apply(currentSnapshot, animatingDifferences: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let tag = self.itemIdentifier(for: indexPath) else { return }
            
            guard let tagIndex = tags.firstIndex(where: { (selectedTag) -> Bool in
                tag == selectedTag
            }) else { return }
            
            tags.remove(at: tagIndex)
            applySnapshot()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - Mock
struct Tag: Hashable{
    var name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func ==(lhs: Tag, rhs: Tag) -> Bool {
        lhs.name == rhs.name
    }
}

enum TagSection {
    case main
}

var tags = [
    Tag(name: "Entertainment"),
    Tag(name: "Chores"),
    Tag(name: "Study"),
    Tag(name: "Planning")
]
