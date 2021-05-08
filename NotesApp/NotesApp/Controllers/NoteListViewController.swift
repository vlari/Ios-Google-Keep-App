//
//  NoteListViewController.swift
//  NotesApp
//
//  Created by Obed Garcia on 4/28/21.
//

import UIKit

class NoteListViewController: UIViewController {
    private var noteCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Note>!
    let searchController = UISearchController()
    var filteredNotes: [Note] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        let isSearchBarFiltered = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || isSearchBarFiltered)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureSearchController()
        configureCollectionView()
        configureDataSource()
        applySnapshot(on: testList)
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
        typealias ShapeDataSource = UICollectionViewDiffableDataSource<Section, Note>
        
        dataSource = ShapeDataSource(collectionView: noteCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, note: Note) ->
            UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.identifier, for: indexPath) as? NoteCollectionViewCell
            else {
                return NoteCollectionViewCell()
            }
            let items = self.isFiltering && !self.filteredNotes.isEmpty ? self.filteredNotes : testList
            let note = items[indexPath.item]
            cell.set(title: note.title, textContent: note.textContent, color: note.color)
            
            return cell
        }
    }
    
    private func applySnapshot(on notes: [Note]) {
        var currentSnapshot = NSDiffableDataSourceSnapshot<Section, Note>()
        currentSnapshot.appendSections([.mainSection])
        currentSnapshot.appendItems(notes)
        dataSource.apply(currentSnapshot, animatingDifferences: true)
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
    
    func filterNotes(text: String) {
        filteredNotes = testList.filter { (note: Note) in
            return note.title.lowercased().contains(text.lowercased()) ||
                note.textContent.lowercased().contains(text.lowercased())
        }
        applySnapshot(on: filteredNotes)
    }
}

// MARK: - Collection Delegate
extension NoteListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemList = isFiltering && !self.filteredNotes.isEmpty ? filteredNotes : testList
        let note = itemList[indexPath.item]
        let noteDetailVC = NoteDetailViewController()
        noteDetailVC.selectedNote = note
        navigationController?.pushViewController(noteDetailVC, animated: true)
    }
}

// MARK: - SearchBar Delegate
extension NoteListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text,
              !searchText.isEmpty else {
            applySnapshot(on: testList)
            return
        }
        filterNotes(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        applySnapshot(on: testList)
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

//struct NoteColor: Hashable {
//    var id = UUID()
//    var bgColor: UIColor
//    var name: String
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}

enum Section {
    case mainSection
}

var testList = [
    Note(id: UUID(),
         title: "Test One",
         textContent: "Text content herehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehere",
         color: UIColor(red: 255/255, green: 244/255, blue: 117/255, alpha: 1.0)),
    Note(id: UUID(),
         title: "Test Two",
         textContent: "Text content here...",
         color: UIColor(red: 255/255, green: 244/255, blue: 117/255, alpha: 1.0))
]
