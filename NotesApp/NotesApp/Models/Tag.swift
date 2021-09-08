//
//  Tag.swift
//  NotesApp
//
//  Created by Obed Garcia on 7/9/21.
//

import Foundation

struct Tag: Hashable {
    let id = UUID().uuidString
    var name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.id == rhs.id
    }
}
