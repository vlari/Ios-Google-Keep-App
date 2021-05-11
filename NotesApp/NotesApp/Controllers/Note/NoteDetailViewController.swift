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
    var selectedNote: NoteEntity!
    let colorContainer = UIView()
    var titleTextView = TextTitleView(frame: .zero, textContainer: nil)
    var descriptionTextView = TextDescriptionView(frame: .zero, textContainer: nil)
    var selectedColor: UIColor!
    var isEditMode = false
    private var isRemoveMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addChildViews()
        configureSubViews()
        configureLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isEditMode == true && isRemoveMode == false {
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
    }
    
    private func configure() {
        if let color = selectedNote?.color {
            selectedColor = UIColor(hex: color)
            let removeButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapRemoveNote))
            navigationItem.rightBarButtonItem = removeButton
        } else {
            selectedColor = UIColor.NoteColor.yellow
        }
        view.backgroundColor = selectedColor
    }
    
    private func addChildViews() {
        switchColor(to: selectedColor)
        
        if let note = selectedNote {
            titleTextView.text = note.title
            descriptionTextView.text = note.textContent
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
    
    private func configureLayout() {
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
            //            titleTextView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 12),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func switchColor(to color: UIColor) {
        titleTextView.backgroundColor = color
        descriptionTextView.backgroundColor = color
        colorContainer.backgroundColor = color
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
    
    // MARK: - Persistence Methods
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
        
        do {
            try managedContext.save()
            completion(.success(true))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
    
    private func update(note item: NoteEntity, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let titleField = titleTextView.text,
              let descriptionField = descriptionTextView.text,
              !titleField.isEmpty,
              !descriptionField.isEmpty else { return }
        
        item.title = titleField
        item.textContent = descriptionField
        let noteColor = self.selectedColor ?? UIColor.NoteColor.yellow
        item.color = noteColor.toHex
        
        do {
            try managedContext.save()
            completion(.success(true))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
    
    private func delete(note item: NoteEntity, completion: @escaping (Result<Bool, Error>) -> ()) {
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
