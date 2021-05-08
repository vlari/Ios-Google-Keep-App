//
//  ColorCollectionViewCell.swift
//  NotesApp
//
//  Created by Obed Garcia on 4/29/21.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    static var identifier = String(describing: ColorCollectionViewCell.self)
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 10
    }
    
    func set(color: UIColor) {
        layer.backgroundColor = color.cgColor
//        if color.name == selected.name {
//            self.layer.borderColor = UIColor.darkGray.cgColor
//            self.layer.borderWidth = 2
//        } else {
//            self.layer.borderColor = nil
//            self.layer.borderWidth = 0
//        }
    }
}
