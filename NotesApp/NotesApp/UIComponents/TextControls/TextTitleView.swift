//
//  TextTitle.swift
//  NotesApp
//
//  Created by Obed Garcia on 4/30/21.
//

import UIKit

class TextTitleView: UITextView {
    var textViewPlaceholder = "Title"

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.delegate = self
        isScrollEnabled = false
        text = textViewPlaceholder
        font = UIFont.preferredFont(forTextStyle: .title1)
    }
}

extension TextTitleView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let totalCharacters = currentText.replacingCharacters(in: stringRange, with: text)
        return totalCharacters.count <= 70
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.text == textViewPlaceholder {
            self.text = ""
            self.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.text.isEmpty {
            self.text = textViewPlaceholder
        }
    }
}
