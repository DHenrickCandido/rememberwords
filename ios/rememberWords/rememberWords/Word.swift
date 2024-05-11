//
//  Words.swift
//  rememberWords
//
//  Created by Diego Henrick on 25/09/23.
//

import Foundation

struct Word: Identifiable, Encodable, Decodable, Equatable {
    var id = UUID()
    var word: String
    var translation: String

    static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.word == rhs.word && lhs.translation == rhs.translation
    }
}


