//
//  DeckManager.swift
//  rememberWords
//
//  Created by Diego Henrick on 11/05/24.
//

import Foundation
import FirebaseFirestoreInternal
import FirebaseCoreInternal
import FirebaseAuth

class DeckManager: ObservableObject {
    var wordsList: [WordNew] = []

    
    func fetchWords() -> [WordNew] {
        wordsList.removeAll()
        let db = Firestore.firestore()

        guard let userID = Auth.auth().currentUser?.uid else { return []}
        print("TESTEEEEE123")

        let ref = db.collection("Users").document(userID).collection("Deck")

        ref.getDocuments { snapshot, error in
//            guard error == nil else {
//                print(error!.localizedDescription)
//                return
//            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let word = data["word"] as? String ?? ""
                    let translation = data["translation"] as? String ?? ""
                    
                    let wordCreated = WordNew(id: id, word: word, translation: translation)
                    self.wordsList.append(wordCreated)
                }
            }
        }
        print("oi currrrrr coi roirori")
        return self.wordsList
    }
    
    func addWord(word: WordNew) {
        let db = Firestore.firestore()
        
        let today = Date.now
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .long
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = db.collection("Users").document(userID).collection("Deck").document(word.id)
        
        ref.setData(["id": word.id, "word": word.word, "translation": word.translation]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        self.wordsList.append(word)
        
    }
    
    
    func deleteWord(id: String) {
        for i in 0..<wordsList.count {
            if wordsList[i].id == id {
                wordsList.remove(at: i)
            }
        }
    }
    
    func removeWord(id: String) {

        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("Users").document(userID).collection("Deck").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        deleteWord(id: id)

    }
}
