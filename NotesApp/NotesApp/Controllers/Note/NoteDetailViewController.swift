//
//  NoteDetailViewController.swift
//  NotesApp
//
//  Created by Obed Garcia on 4/29/21.
//

import UIKit
import CoreData

class NoteDetailViewController: UIViewController {
    var managedContext: NSManagedObjectContext!
    var selectedNote: NSManagedObject!
    let colorContainer = UIView()
    var titleTextView = TextTitleView(frame: .zero, textContainer: nil)
    var descriptionTextView = TextDescriptionView(frame: .zero, textContainer: nil)
    var tagList = [Tag]()
    var selectedColor: UIColor!
    var isEditMode = false
    private var isRemoveMode = false
    private var originalNote = NoteModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addChildViews()
        configureSubViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isEditMode == true && isRemoveMode == false && isNoteModified() {
            update(note: selectedNote) { (result) in
                switch result {
                case .success(let isNoteSaved):
                    if isNoteSaved {
                        print("Note updated")
                    }
                case .failure(let error):
                    print("error \(error)")
                }
            }
        } else if isRemoveMode == false {
            saveNote { (result) in
                switch result {
                case .success(let isNoteSaved):
                    if isNoteSaved {
                        print("Note saved")
                    }
                case .failure(let error):
                    print("error \(error)")
                }
            }
        }
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            colorContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            colorContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            colorContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            colorContainer.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: colorContainer.bottomAnchor, constant: 16),
            titleTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            titleTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
        ])
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 12),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Methods
    private func configure() {
        let tagsButton = UIBarButtonItem(image: UIImage(systemName: "tag"), style: .plain, target: self, action: #selector(didTapTags))
        var buttonItems = [tagsButton]
        
        if isEditMode {
            let removeButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapRemoveNote))
            buttonItems.append(removeButton)
        }
        
        navigationItem.rightBarButtonItems = buttonItems
        
        if let color = selectedNote?.value(forKey: "color") as? String {
            selectedColor = UIColor(hex: color)
        } else {
            selectedColor = UIColor.NoteColor.yellow
        }
        view.backgroundColor = selectedColor
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func addChildViews() {
        switchColor(to: selectedColor)

        if isEditMode == true {
            titleTextView.text = selectedNote?.value(forKey: "title") as? String ?? ""
            descriptionTextView.text = selectedNote?.value(forKey: "textContent") as? String ?? ""
            let tagString = selectedNote.value(forKey: "tags") as? String ?? ""
            let tags = tagString.isEmpty ? [String]() : tagString.components(separatedBy: ",")
            tagList = tags.map { Tag(name: $0) }
            
            originalNote.title = titleTextView.text
            originalNote.textContent = descriptionTextView.text
            originalNote.tags = tagString
            originalNote.color = selectedColor.toHex!
        }
        
        let childViews = [titleTextView, descriptionTextView, colorContainer]
        
        for viewItem in childViews {
            view.addSubview(viewItem)
            viewItem.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configureSubViews() {
        let colorCollectionVC = ColorCollectionViewController(color:  selectedColor)
        colorCollectionVC.colorDelegate = self
        add(colorCollectionVC, container: colorContainer)
    }
    
    private func switchColor(to color: UIColor) {
        titleTextView.backgroundColor = color
        descriptionTextView.backgroundColor = color
        colorContainer.backgroundColor = color
    }
    
    private func isNoteModified() -> Bool {
        let currentNote = NoteModel()
        currentNote.title = titleTextView.text
        currentNote.textContent = descriptionTextView.text
        let tagNames = tagList.map { $0.name }
        currentNote.tags = tagNames.joined(separator: ",")
        currentNote.color = selectedColor.toHex!
        
        return !(currentNote == originalNote)
    }
    
    @objc func didTapRemoveNote() {
        delete(note: selectedNote) { (result) in
            switch result {
            case .success(let isRemoved):
                if isRemoved {
                    print("Note removed")
                    self.isRemoveMode = true
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            case .failure(let error):
                print("Error \(error)")
            }
        }
    }
    
    @objc func didTapTags() {
        let tagVC = TagListViewController()
        tagVC.tags = tagList
        tagVC.title = "Tags"
        tagVC.navigationController?.navigationBar.prefersLargeTitles = true
        tagVC.tagListDelegate = self
        let navVC = UINavigationController(rootViewController: tagVC)
        present(navVC, animated: true, completion: nil)
    }
    
    // MARK: - Database Methods
    private func saveNote(completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let titleField = titleTextView.text,
              let descriptionField = descriptionTextView.text,
              !titleField.isEmpty && titleField != titleTextView.textViewPlaceholder,
              !descriptionField.isEmpty && descriptionField != descriptionTextView.textViewPlaceholder else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: "NoteEntity", in: managedContext) else { return }

        let note = NoteEntity(entity: entity, insertInto: managedContext)
        note.title = titleField
        note.textContent = descriptionField
        
        let noteColor = self.selectedColor ?? UIColor.NoteColor.yellow
        note.color = noteColor.toHex
        
        let tagNames = tagList.map { $0.name }
        note.tags = tagNames.joined(separator: ",")
        
        do {
            try managedContext.save()
            completion(.success(true))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
    
    private func update(note item: NSManagedObject, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let titleField = titleTextView.text,
              let descriptionField = descriptionTextView.text,
              !titleField.isEmpty,
              !descriptionField.isEmpty else { return }
        
        item.setValue(titleTextView.text, forKey: "title")
        item.setValue(descriptionTextView.text, forKey: "textContent")
        
        let noteColor = self.selectedColor ?? UIColor.NoteColor.yellow
        item.setValue(noteColor.toHex, forKey: "color")
        
        let tagNames = tagList.map { $0.name }
        item.setValue(tagNames.joined(separator: ","), forKey: "tags")
        
        do {
            try managedContext.save()
            completion(.success(true))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
    
    private func delete(note item: NSManagedObject, completion: @escaping (Result<Bool, Error>) -> ()) {
        do {
            managedContext.delete(item)
            try managedContext.save()
            completion(.success(true))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
}

// MARK: - CollorCollection Delegate
extension NoteDetailViewController: ColorCollectionViewDelegate {
    func didSelectColor(color: UIColor) {
        view.backgroundColor = color
        selectedColor = color
        switchColor(to: color)
    }
}

// MARK: - TagList Delegate
extension NoteDetailViewController: TagListViewDelegate {
    func didUpdateTagList(tagList: [Tag]) {
        self.tagList = tagList
    }
}
