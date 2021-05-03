//
//  UIViewControllerExtension.swift
//  NotesApp
//
//  Created by Obed Garcia on 4/30/21.
//

import UIKit

extension UIViewController {
    func add(_ child: UIViewController, container parent: UIView) {
        addChild(child)
        parent.addSubview(child.view)
        child.view.frame = parent.bounds
        child.didMove(toParent: self)
    }
}
