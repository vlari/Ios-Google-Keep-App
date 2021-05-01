//
//  NoteCollectionViewCell.swift
//  NotesApp
//
//  Created by Obed Garcia on 4/28/21.
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: NoteCollectionViewCell.self)
    let title = CustomStyledLabel(textAlign: .left, style: .title2, color: .label)
    let textContent = CustomStyledLabel(textAlign: .left, style: .body, color: .systemGray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    func set(title: String, textContent: String, color: UIColor) {
        self.title.text = title
        self.textContent.text = textContent
        self.backgroundColor = color
    }
    
    private func configureLayout() {
        addSubview(title)
        addSubview(textContent)
        title.translatesAutoresizingMaskIntoConstraints = false
        textContent.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 15
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            title.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            textContent.topAnchor.constraint(equalTo: title.bottomAnchor, constant: padding),
            textContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            textContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            textContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
}
