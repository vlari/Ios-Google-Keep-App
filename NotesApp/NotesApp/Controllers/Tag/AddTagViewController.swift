//
//  AddTagViewController.swift
//  NotesApp
//
//  Created by Obed Garcia on 5/5/21.
//

import UIKit
import CoreData

class AddTagViewController: UIViewController {
    var managedContext: NSManagedObjectContext!
    var tagLabel = CustomStyledLabel(textAlign: .left, style: .title1, color: .label)
    var tagField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveTag { (result) in
            switch result {
            case .success(let isTagSaved):
                if isTagSaved {
                    print("saved")
                }
            case .failure(let error):
                print("error \(error)")
            break
            }
        }
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDismiss))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 241/255, green: 100/255, blue: 100/255, alpha: 1.0)
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configureLayout() {
        view.addSubview(tagLabel)
        view.addSubview(tagField)
        
        tagLabel.text = "Add a Tag"
        tagField.font = UIFont.preferredFont(forTextStyle: .title2)
        tagField.backgroundColor = .white
        tagField.layer.borderWidth = 1.0
        tagField.layer.borderColor = UIColor.systemGray.cgColor
        tagField.layer.cornerRadius = 10
        tagField.textAlignment = .center
        
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            tagLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            tagLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            tagLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            tagField.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 40),
            tagField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tagField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tagField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func didTapDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    private func saveTag(completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let field = tagField.text,
              !field.isEmpty else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: "TagEntity", in: managedContext) else { return }
        
        let tag = TagEntity(entity: entity, insertInto: managedContext)
        tag.name = field
        
        do {
            try managedContext.save()
            completion(.success(true))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
}
