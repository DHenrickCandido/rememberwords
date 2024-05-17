//
//  AddWordView.swift
//  rememberWords
//
//  Created by Diego Henrick on 30/09/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

//struct Example_test: View {
//    @State var showAddWord: Bool = false
//    @State var wordBank = [Word(word: "test", translation: "teste"),Word(word: "OIE", translation: "teste"), Word(word: "TCHAUUU", translation: "teste"), Word(word: "POGGERS", translation: "teste")]
//    
//    var body: some View {
//        Button("click me") {
//            showAddWord.toggle()
//        }
//        .sheet(isPresented: $showAddWord){
//            NewWordView(showAddWord: $showAddWord, wordBank: $wordBank)
//                .presentationDetents([.fraction(0.7)])
//                .interactiveDismissDisabled()
//        }
//
//    }
//}

struct NewWordView: View {
    @Binding var showAddWord: Bool
    @State var word: String = ""
    @State var translation: String = ""
    
//    @Binding var wordBank: [Word]
    @Binding var wordBank: [WordNew]
    @State var deckManager = DeckManager()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40){
            
            ZStack {
                
                HStack {
                    Image(systemName: "xmark")
                        .fontWeight(.bold)
                        .onTapGesture {
                            showAddWord.toggle()
                        }
                    
                    Spacer()
                    
                    Text("")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                }
                Text("Add new word")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            ScrollView{
                VStack (alignment: .leading) {
                    Text("New word:")
                        .font(.headline)
                        .bold()
                    
                    HStack(alignment: .top, spacing: 10) {
                        TextField("Type the word you learned", text: $word)
                            .font(.callout)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .padding(16)
                            .frame(maxWidth: .infinity)
                            .background(Color("GreenSecondary"))
                            .cornerRadius(8)
                    }
                }
                
                VStack (alignment: .leading) {
                    Text("Translation:")
                        .font(.headline)
                        .bold()
                    
                    HStack(alignment: .top, spacing: 10) {
                        TextField("Type the translation", text: $translation)
                            .font(.callout)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .padding(16)
                            .frame(maxWidth: .infinity)
                            .background(Color("GreenSecondary"))
                            .cornerRadius(8)
                    }
                    
                    
                }
                Spacer()
                
                HStack {
                    
                    
                    Spacer()
                    Text("Add")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 54)
                        .background(Color("GreenPrimary"))
                        .cornerRadius(8)
                        .onTapGesture {
                            addWord(word: WordNew(id: createId(word: word), word: word, translation: translation))
                            //                        deckManager.fetchWords()
                            //                        wordBank = deckManager.wordsList
                            //                        wordBank.append(Word(word: word, translation: translation))
                            //                        
                            //                        let data = try? JSONEncoder().encode(wordBank)
                            //                        
                            //                        // Use UserDefaults com o suiteName
                            //                        if let suiteDefaults = UserDefaults(suiteName: "group.com.diegohenrick.remember") {
                            //                            suiteDefaults.set(data, forKey: "wordBank")
                            //                        }
                            showAddWord.toggle()
                        }
                    Spacer()
                }
            }
        }.padding(16)
            
    }
    public func createId(word: String) -> String {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyyMMddHHmmssSSS"
        let today = Date()
        return String(word + formatter1.string(from: today)).replacingOccurrences(of: " ", with: "")
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
        wordBank.append(word)
        
    }
}

//#Preview {
//    Example_test()
//}
