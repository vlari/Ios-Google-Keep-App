//
//  NoteListViewController.swift
//  NotesApp
//
//  Created by Obed Garcia on 4/28/21.
//

import UIKit
import CoreData

class NoteListViewController: UIViewController {
    var managedContext: NSManagedObjectContext!
    private var noteCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<NoteSection, NoteEntity>!
    let searchController = UISearchController()
    var searchedText: String = ""
    lazy var fetchedResultsController: NSFetchedResultsController<NoteEntity> = {
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        let nameSort = NSSortDescriptor(key: #keyPath(NoteEntity.createdAt), ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        fetchRequest.fetchBatchSize = 20
        
        if !searchedText.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@ OR name CONTAINS[c] %@", searchedText)
        }
        
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
        configureSearchController()
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.performWithoutAnimation {
            fetchNotes()
        }
    }

    private func configure() {
        view.backgroundColor = .systemBackground
        title = "Quick Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func didTapAddNote() {
        let noteDetailVC = NoteDetailViewController()
        navigationController?.pushViewController(noteDetailVC, animated: true)
    }
    
    private func configureCollectionView() {
        noteCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        noteCollectionView.delegate = self
        view.addSubview(noteCollectionView)
        noteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        noteCollectionView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            noteCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noteCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            noteCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            noteCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        noteCollectionView.register(NoteCollectionViewCell.self, forCellWithReuseIdentifier: NoteCollectionViewCell.identifier)
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let sectonPadding: CGFloat = 10
        let itemPadding: CGFloat = 8
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: itemPadding, leading: itemPadding, bottom: itemPadding, trailing: itemPadding)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: sectonPadding, leading: sectonPadding, bottom: sectonPadding, trailing: sectonPadding)

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureDataSource() {
        typealias NoteDataSource = UICollectionViewDiffableDataSource<NoteSection, NoteEntity>
        
        dataSource = NoteDataSource(collectionView: noteCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, note: NoteEntity) ->
            UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.identifier, for: indexPath) as? NoteCollectionViewCell
            else {
                return NoteCollectionViewCell()
            }
            
            cell.set(title: note.title, textContent: note.textContent, color: note.color)
            
            return cell
        }
    }
    
    private func applySnapshot() {
        var currentSnapshot = NSDiffableDataSourceSnapshot<NoteSection, NoteEntity>()
        currentSnapshot.appendSections([.mainSection])
        currentSnapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
        dataSource.apply(currentSnapshot)
    }
    
    func configureSearchController() {
        searchController.searchBar.placeholder = ""
        searchController.searchBar.barTintColor = .white
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func fetchNotes() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("error \(error)")
        }
    }
}

// MARK: - Collection Delegate
extension NoteListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let note = dataSource.itemIdentifier(for: indexPath) else { return }
        let noteDetailVC = NoteDetailViewController()
        noteDetailVC.managedContext = managedContext
        noteDetailVC.selectedNote = note
        noteDetailVC.isEditMode = true
        navigationController?.pushViewController(noteDetailVC, animated: true)
    }
}

// MARK: - SearchBar Delegate
extension NoteListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text,
              !searchText.isEmpty else {
            return
        }
        searchedText = searchText
        fetchNotes()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchNotes()
    }
}

// MARK: - NSFetchedResultsController Delegate
extension NoteListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        applySnapshot()
    }
}

struct Note: Hashable {
    var id = UUID()
    var title: String
    var textContent: String
    var color: UIColor
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Note, rhs: Note) -> Bool {
        lhs.id == rhs.id
    }
}

enum NoteSection {
    case mainSection
}
