//
//  TextDescription.swift
//  NotesApp
//
//  Created by Obed Garcia on 4/30/21.
//

import UIKit

class TextDescriptionView: UITextView {
    var textViewPlaceholder = "Add a new note"
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.delegate = self
        isScrollEnabled = true
        text = textViewPlaceholder
        font = UIFont.preferredFont(forTextStyle: .body)
    }
}

extension TextDescriptionView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.text == textViewPlaceholder {
            self.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.text.isEmpty {
            self.text = textViewPlaceholder
        }
    }
}
