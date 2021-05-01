//
//  NoteListViewController.swift
//  NotesApp
//
//  Created by Obed Garcia on 4/28/21.
//

import UIKit

class NoteListViewController: UIViewController {

    var noteCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Note>!
    var testList: [Note] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        testList = [
            Note(id: UUID(),
                 title: "Test One",
                 textContent: "Text content herehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehereherehere",
                 color: NoteColor(bgColor: UIColor.blue, name: "Blue")),
            Note(id: UUID(),
                 title: "Test Two",
                 textContent: "Text content here...",
                 color: NoteColor(bgColor: UIColor.green, name: "Green"))
        ]
        configureCollectionView()
        configureDataSource()
        applySnapshot(on: testList)
    }

    private func configure() {
        view.backgroundColor = .systemBackground
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
        
        dataSource = ShapeDataSource(collectionView: noteCollectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, shape: Note) ->
            UICollectionViewCell? in
            guard let self = self else { return nil }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.identifier, for: indexPath) as? NoteCollectionViewCell
            else {
                return NoteCollectionViewCell()
            }
            
            let note = self.testList[indexPath.item]
            cell.set(title: note.title, textContent: note.textContent, color: note.color.bgColor)
//            cell.backgroundColor = .systemTeal
            
            return cell
        }
    }
    
    private func applySnapshot(on notes: [Note]) {
        var currentSnapshot = NSDiffableDataSourceSnapshot<Section, Note>()
        currentSnapshot.appendSections([.mainSection])
        currentSnapshot.appendItems(notes)
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
}

extension NoteListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let note = testList[indexPath.item]
        let noteDetailVC = NoteDetailViewController()
        noteDetailVC.note = note
        navigationController?.pushViewController(noteDetailVC, animated: true)
    }
}

struct Note: Hashable {
    var id = UUID()
    var title: String
    var textContent: String
    var color: NoteColor
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Note, rhs: Note) -> Bool {
        lhs.id == rhs.id
    }
}

struct NoteColor: Hashable {
    var id = UUID()
    var bgColor: UIColor
    var name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum Section {
    case mainSection
}
