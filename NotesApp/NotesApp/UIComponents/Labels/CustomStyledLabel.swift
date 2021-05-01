//
//  CustomStyledLabel.swift
//  NotesApp
//
//  Created by Obed Garcia on 4/29/21.
//

import UIKit

class CustomStyledLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    init(textAlign: NSTextAlignment, style: UIFont.TextStyle, color: UIColor) {
        super.init(frame: .zero)
        self.textAlignment = textAlign
        self.textColor = color
        self.font = UIFont.preferredFont(forTextStyle: style)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
