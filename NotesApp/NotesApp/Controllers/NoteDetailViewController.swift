//
//  NoteDetailViewController.swift
//  NotesApp
//
//  Created by Obed Garcia on 4/29/21.
//

import UIKit

class NoteDetailViewController: UIViewController {
    var selectedNote: Note!
    let colorContainer = UIView()
    var titleTextView = TextTitleView(frame: .zero, textContainer: nil)
    var descriptionTextView = TextDescriptionView(frame: .zero, textContainer: nil)
    var selectedColor: NoteColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addChildViews()
        configureSubViews()
        configureLayout()
    }
    
    private func configure() {
        selectedColor = selectedNote?.color ?? noteColors.first
        view.backgroundColor = selectedColor.bgColor
    }
    
    private func addChildViews() {
        switchColor(to: selectedColor.bgColor)
        
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
}

extension NoteDetailViewController: ColorCollectionViewDelegate {
    func didSelectColor(color: NoteColor) {
        view.backgroundColor = color.bgColor
        switchColor(to: color.bgColor)
    }
}
