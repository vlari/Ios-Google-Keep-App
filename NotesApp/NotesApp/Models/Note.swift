//
//  Note.swift
//  NotesApp
//
//  Created by Obed Garcia on 7/9/21.
//

import Foundation

class NoteModel: Equatable {
    var title: String = ""
    var textContent: String = ""
    var color: String = ""
    var tags: String = ""
    
//    init(title: String, textContent: String, color: String, tags: String) {
//        self.title = title
//        self.textContent = textContent
//        self.color = color
//        self.tags = tags
//    }
    
    public static func == (lhs: NoteModel, rhs: NoteModel) -> Bool {
        return lhs.title == rhs.title &&
            lhs.textContent == rhs.textContent &&
            lhs.color == rhs.color &&
            lhs.tags == rhs.tags
    }
}
