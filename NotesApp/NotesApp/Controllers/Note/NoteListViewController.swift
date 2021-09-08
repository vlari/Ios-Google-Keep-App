//
//  NoteListViewController.swift
//  NotesApp
//
//  Created by Obed Garcia on 4/28/21.
//

import UIKit
import CoreData

protocol NoteListViewDelegate: AnyObject {
    func getNotes()
}

class NoteListViewController: UIViewController {
    var managedContext: NSManagedObjectContext!
    var noteCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<NoteSection, NSManagedObjectID>!
    
    weak var noteListDelegate: NoteListViewDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.performWithoutAnimation {
            noteListDelegate?.getNotes()
        }
    }

    // MARK: - Methods
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
        typealias NoteDataSource = UICollectionViewDiffableDataSource<NoteSection, NSManagedObjectID>
        
        dataSource = NoteDataSource(collectionView: noteCollectionView, cellProvider: { [weak self] (collectionView, indexPath, objectID) -> UICollectionViewCell? in
            
            guard let object = try? self?.managedContext.existingObject(with: objectID) else { return UICollectionViewCell() }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.identifier, for: indexPath) as? NoteCollectionViewCell
            else {
                return NoteCollectionViewCell()
            }
            
            let title = object.value(forKey: "title") as? String ?? ""
            let textContent = object.value(forKey: "textContent") as? String ?? ""
            let color = object.value(forKey: "color") as? String ?? ""
            
            cell.set(title: title, textContent: textContent, color: color)
            
            return cell
        })
    }
    
    @objc func didTapAddNote() {
        let noteDetailVC = NoteDetailViewController()
        navigationController?.pushViewController(noteDetailVC, animated: true)
    }
}

// MARK: - Collection Delegate
extension NoteListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let objectID = dataSource.itemIdentifier(for: indexPath) else { return }
        guard let note = try? managedContext.existingObject(with: objectID) else { return }
                
        let noteDetailVC = NoteDetailViewController()
        noteDetailVC.managedContext = managedContext
        noteDetailVC.selectedNote = note
        noteDetailVC.isEditMode = true
        noteDetailVC.title = "Note"
        navigationController?.pushViewController(noteDetailVC, animated: true)
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
