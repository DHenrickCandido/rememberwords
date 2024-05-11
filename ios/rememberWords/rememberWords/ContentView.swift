//
//  ContentView.swift
//  rememberWords
//
//  Created by Diego Henrick on 25/09/23.
//

import SwiftUI

struct ContentView: View {
    @State private var word: String = ""
    @State private var translation: String = ""
    
    @State var wordBank: [Word] = []
    
    var body: some View {
        VStack {
            HStack{
                Text("Insert the new word")
                Spacer()
            }
            HStack{
                TextField(
                    "Learned word",
                    text: $word
                ).padding(.leading, 4)
                    .padding(.vertical, 4)
                    .border(.secondary)
                
                    .disableAutocorrection(true)
                    .frame(width: 200)
                Spacer()
            }
            
            HStack{
                Text("Insert the translation")
                Spacer()
            }
            HStack{
                TextField(
                    "Translated word",
                    text: $translation
                ).padding(.leading, 4)
                    .padding(.vertical, 4)
                    .border(.secondary)
                
                    .disableAutocorrection(true)
                    .frame(width: 200)
                Spacer()
            }
            
            Button {
                wordBank.append(Word(word: word, translation: translation))
//                wordBank.removeAll()
                saveWordBank()

            } label: {
                Text("Send")
                
            }.padding()
                .buttonStyle(.borderedProminent)
            
            Spacer()
            
            VStack{
                ForEach(wordBank) { word in
                    HStack{
                        Text(word.word)
                        Text(word.translation)
                    }
                    
                }
                Spacer()
            }
        }
        .padding()
        .onAppear(){
            loadWordBank()
        }
        
    }
    func saveWordBank() {
        let data = try? JSONEncoder().encode(wordBank)
        
        // Use UserDefaults com o suiteName
        if let suiteDefaults = UserDefaults(suiteName: "group.com.diegohenrick.remember") {
            suiteDefaults.set(data, forKey: "wordBank")
        }
    }

    func loadWordBank() {
        // Use UserDefaults com o suiteName
        if let data = UserDefaults(suiteName: "group.com.diegohenrick.remember")?.data(forKey: "wordBank") {
            if let loadedWordBank = try? JSONDecoder().decode([Word].self, from: data) {
                wordBank = loadedWordBank
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
