//
//  AddTagViewController.swift
//  NotesApp
//
//  Created by Obed Garcia on 5/5/21.
//

import UIKit
import CoreData

class AddTagViewController: UIViewController {
    var manageContext: NSManagedObjectContext!
    var tagLabel = CustomStyledLabel(textAlign: .left, style: .title2, color: .label)
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
                } else {
                    print("error saved")
                }
            case .failure(let error):
                print("error \(error)")
            break
            }
        }
    }
    
    private func configure() {
        title = "Add Tag"
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDismiss))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 241/255, green: 100/255, blue: 100/255, alpha: 1.0)
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configureLayout() {
        view.addSubview(tagLabel)
        view.addSubview(tagField)
        
        tagLabel.text = "Name"
        tagField.font = UIFont.preferredFont(forTextStyle: .title2)
        tagField.backgroundColor = .white
        tagField.layer.borderWidth = 1.0
        tagField.layer.borderColor = UIColor.systemGray.cgColor
        tagField.layer.cornerRadius = 10
        
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            tagLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            tagLabel.widthAnchor.constraint(equalToConstant: 64),
            tagLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            tagField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            tagField.leadingAnchor.constraint(equalTo: tagLabel.trailingAnchor, constant: 12),
            tagField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            tagField.bottomAnchor.constraint(equalTo: tagLabel.bottomAnchor)
        ])
    }
    
    @objc func didTapDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    private func saveTag(completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let field = tagField.text,
              !field.isEmpty else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: "TagEntity", in: manageContext) else { return }
        
        let tag = TagEntity(entity: entity, insertInto: manageContext)
        tag.name = field
        
        do {
            try manageContext.save()
            completion(.success(true))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
}
