//
//  WordNew.swift
//  rememberWords
//
//  Created by Diego Henrick on 11/05/24.
//

import Foundation

struct WordNew: Identifiable, Encodable, Decodable, Equatable {
    var id: String
    var word: String
    var translation: String

    static func == (lhs: WordNew, rhs: WordNew) -> Bool {
        return lhs.word == rhs.word && lhs.translation == rhs.translation
    }
}
