//
//  ToggleStateIntent.swift
//  rememberWords
//
//  Created by Diego Henrick on 01/10/23.
//

import SwiftUI
import AppIntents

struct ToggleStateIntent: AppIntent {

    
    static var title: LocalizedStringResource = "idk what im doing"
    
    @Parameter(title: "word")
    var word: String
    
    @Parameter(title: "translation")
    var translation: String
    
    @Parameter(title: "isTurned")
    var isTurned: String
    
    @Parameter(title: "buttonActed")
    var buttonActed: String
    
    init() {

    }

    init(word: String, translation: String, isTurned: String, buttonActed: String) {
        self.word = word
        self.translation = translation
        self.isTurned = isTurned
        self.buttonActed = buttonActed
    }
    

    
    func perform() async throws -> some IntentResult {
        if self.isTurned == "true" {
            self.isTurned = "false"
        } else {
            self.isTurned = "true"
        }
        
        let wordSelected: [String] = [self.word, self.translation, self.isTurned, self.buttonActed]
        
        let data = try? JSONEncoder().encode(wordSelected)
        // Use UserDefaults com o suiteName
        if let suiteDefaults = UserDefaults(suiteName: "group.com.diegohenrick.remember") {
            suiteDefaults.set(data, forKey: "wordSelected")
        }
        

        
        print("PASSOU PELO BOTAO")
        
        return .result()
    }
    
    func loadWordSelected() -> [String]? {
        if let data = UserDefaults(suiteName: "group.com.diegohenrick.remember")?.data(forKey: "wordSelected") {
            if let loadedWordSelected = try? JSONDecoder().decode([String].self, from: data) {
                return loadedWordSelected
            }
        }
        
        return nil
    }
}
