//
//  NoteDetailViewController.swift
//  NotesApp
//
//  Created by Obed Garcia on 4/29/21.
//

import UIKit

class NoteDetailViewController: UIViewController {
    let colorContainer = UIView()
    var titleTextView = TextTitleView(frame: .zero, textContainer: nil)
    var descriptionTextView = TextDescriptionView(frame: .zero, textContainer: nil)
    var note: Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemTeal
        configureSubViews()
        configureLayout()
    }
    
    private func configureSubViews() {
        titleTextView.backgroundColor = .systemTeal
        descriptionTextView.backgroundColor = .systemTeal
        colorContainer.backgroundColor = .systemTeal
       
        view.addSubview(colorContainer)
        view.addSubview(titleTextView)
        view.addSubview(descriptionTextView)
        
        colorContainer.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let colorCollectionVC = ColorCollectionViewController(color: note.color.bgColor)
        add(colorCollectionVC, container: colorContainer)
    }
    
    private func add(_ child: UIViewController, container parent: UIView) {
        addChild(child)
        parent.addSubview(child.view)
        child.view.frame = parent.bounds
        child.didMove(toParent: self)
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

}
