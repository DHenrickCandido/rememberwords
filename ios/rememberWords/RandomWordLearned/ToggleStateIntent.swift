//
//  ToggleStateIntent.swift
//  rememberWords
//
//  Created by Diego Henrick on 01/10/23.
//

import SwiftUI
import AppIntents
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

struct ToggleStateIntent: AppIntent {
    static var title: LocalizedStringResource = "idk what im doing"
    
    @Parameter(title: "idWord")
    var idWord: String
    
    @Parameter(title: "word")
    var word: String
    
    @Parameter(title: "translation")
    var translation: String
    
    @Parameter(title: "isTurned")
    var isTurned: Bool
    
    @Parameter(title: "buttonActed")
    var buttonActed: String
    
    init() {
        
    }

    init(idWord: String, word: String, translation: String, isTurned: Bool, buttonActed: String) {
        self.idWord = idWord
        self.word = word
        self.translation = translation
        self.isTurned = isTurned
        self.buttonActed = buttonActed
    }
    
    func perform() async throws -> some IntentResult {
        if self.isTurned == true {
            updateSelectedWordSide(isTurned: false)
        } else if self.isTurned == false {
            updateSelectedWordSide(isTurned: true)
        }
        UserDefaults.standard.set(true, forKey: "isButtonTurn")

        return .result()
    }
    
    func updateSelectedWordSide(isTurned: Bool) {
        UserDefaults.standard.set(isTurned, forKey: "RandomWord.isTurned")
    }
}
