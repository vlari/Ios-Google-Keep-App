//
//  TagTableViewCell.swift
//  NotesApp
//
//  Created by Obed Garcia on 5/1/21.
//

import UIKit

class TagTableViewCell: UITableViewCell {
    static var identifier = String(describing: TagTableViewCell.self)
    var tagImageView = UIImageView()
    var tagNameLabel = CustomStyledLabel(textAlign: .left, style: .title3, color: .label)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubViews()
        configureLayout()
    }
    
    private func configureSubViews() {
        tagImageView.image = UIImage(systemName: "tag")
        tagImageView.tintColor = .label
        tagImageView.clipsToBounds = true
        tagImageView.contentMode = .scaleAspectFit
        tagNameLabel.numberOfLines = 0
        addSubview(tagImageView)
        addSubview(tagNameLabel)
        tagImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            tagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tagImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            tagImageView.heightAnchor.constraint(equalToConstant: 32),
            tagImageView.widthAnchor.constraint(equalTo: tagImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tagNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            tagNameLabel.leadingAnchor.constraint(equalTo: tagImageView.trailingAnchor, constant: 12),
            tagNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            tagNameLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func set(tag name: String) {
        tagNameLabel.text = name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
