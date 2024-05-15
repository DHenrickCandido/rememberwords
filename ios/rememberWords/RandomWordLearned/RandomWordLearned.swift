//
//  RandomWordLearned.swift
//  RandomWordLearned
//
//  Created by Diego Henrick on 25/09/23.
//

import WidgetKit
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct Provider: TimelineProvider {
    @State var wordBank: [WordNew] = []
    @State var selectedWord: WordNew = WordNew(id: "", word: "", translation: "")
    @State var isTurned = false
    
    init() {
//        updateSelectedWord(selectNew: true)
        selectedWord = updateSelectedWord()
    }
    func placeholder(in context: Context) -> SimpleEntry {
        selectedWord = updateSelectedWord()

        return SimpleEntry(date: Date(), selectedWordEntry: WordNew(id: selectedWord.id, word: selectedWord.word, translation: selectedWord.translation), isTurned: isTurned)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        selectedWord = updateSelectedWord()

        let entry = SimpleEntry(date: Date(), selectedWordEntry: selectedWord, isTurned: isTurned)
        print("testsetestsetsetset")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
//        updateSelectedWord(selectNew: true)
        selectedWord = updateSelectedWord()

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
                
        
        let entry = SimpleEntry(date: Date(), selectedWordEntry: selectedWord, isTurned: isTurned)
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .after(Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!))
        completion(timeline)
    }
    
    func updateSelectedWord(selectNew: Bool) {
//        wordBank.removeAll()
        var wordsBank: [WordNew] = []
        let db = Firestore.firestore()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let ref = db.collection("Users").document(userID).collection("Deck")
        
        ref.getDocuments { snapshot, error in
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let id = data["id"] as? String ?? ""
                    let word = data["word"] as? String ?? ""
                    let translation = data["translation"] as? String ?? ""
                    let isTurnedData = data["isTurned"] as? Bool ?? false
                    let wordCreated = WordNew(id: id, word: word, translation: translation)
                    isTurned = isTurnedData
                    wordsBank.append(wordCreated)
                }
            }
            var selectedWordNew = wordsBank.randomElement() ?? WordNew(id: "teste", word: "", translation: "")
            let ref2 = db.collection("Users").document(userID).collection("SelectedWord").document("word")
            
            ref2.setData(["id": selectedWordNew.id, "word": selectedWordNew.word, "translation": selectedWordNew.translation, "isTurned": "false"]) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            selectedWord = selectedWordNew

        }
    }
    
    func updateSelectedWord() -> WordNew {
        var selectedWordNova = WordNew(id: "", word: "", translation: "")
        let db = Firestore.firestore()
        
        guard let userID = Auth.auth().currentUser?.uid else { return WordNew(id: "", word: "", translation: "") }
        let ref = db.collection("Users").document(userID).collection("Deck")
        
        ref.getDocuments { snapshot, error in
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let id = data["id"] as? String ?? ""
                    let word = data["word"] as? String ?? ""
                    let translation = data["translation"] as? String ?? ""
                    let isTurnedData = data["isTurned"] as? Bool ?? false
                    let wordCreated = WordNew(id: id, word: word, translation: translation)
                    isTurned = isTurnedData
                    selectedWordNova = wordCreated
                    
                }
            }
        }
        return selectedWordNova
    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let selectedWordEntry: WordNew?
    let isTurned: Bool?
}

struct RandomWordLearnedEntryView : View {
    @State var entry: Provider.Entry
    @State var test: Bool = true
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        @State var randomWord = entry.selectedWordEntry
        @State var id: String = randomWord?.id ?? ""
        @State var word: String = randomWord?.word ?? ""
        @State var translation: String = randomWord?.translation ?? ""
        @State var isTurned: Bool = entry.isTurned ?? false
        
        switch widgetFamily {
        case .systemSmall:
            VStack() {
                HStack{
                    Text("You learned")
                        .opacity(0.4)
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .padding(.top)
                        .padding(.horizontal)
                    Spacer()
                }
            
                Spacer()
                Text(isTurned ? translation : word)
                    .font(.title3)
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .contentTransition(.opacity)
                    .invalidatableContent()
                    .padding(.top, 8)
                Spacer()
                Spacer()
                Button(intent: ToggleStateIntent(idWord: id, 
                                                 word: word,
                                                 translation: translation,
                                                 isTurned: isTurned,
                                                 buttonActed: "true")) {
                    Text("Turn")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .background(Color("GreenPrimary"))
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                }.buttonStyle(.plain)
            }
            .frame(width: 160, height: 160)
            .animation(.easeInOut, value: isTurned)
            .background(Color("GreenSecondary"))
            .containerBackground(.blue.gradient, for: .widget)
            
        case .systemMedium:
            VStack() {
                HStack{
                    Text("You learned")
                        .opacity(0.4)
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .padding(.top)
                        .padding(.horizontal)
                    Spacer()
                }
                Spacer()
                HStack {
                    Text(isTurned ? translation : word)
                        .font(.title3)
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .contentTransition(.opacity)
                        .invalidatableContent()
                        .padding(.top, 8)
                    Spacer()
                }
                
                Spacer()
                Spacer()
                
                Button(intent: ToggleStateIntent(idWord: id,
                                                 word: word,
                                                 translation: translation,
                                                 isTurned: isTurned,
                                                 buttonActed: "true")) {
                    Text("Turn")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .background(Color("GreenPrimary"))
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                }.buttonStyle(.plain)
            }
            .frame(width: 340, height: 160)
            .animation(.easeInOut, value: isTurned)
            .background(Color("GreenSecondary"))
            .containerBackground(.blue.gradient, for: .widget)        
        default:
            Text("Default")
        }
    }
}

@main
struct RandomWordLearned: Widget {
    
    init() {
        FirebaseApp.configure()
          do {
              try Auth.auth().useUserAccessGroup("\(teamID).com.candidohdiego.rememberWords")
          } catch {
              print(error.localizedDescription)
          }
    }
    let kind: String = "RandomWordLearned"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RandomWordLearnedEntryView(entry: entry)
        }
        .configurationDisplayName("RememberWords Widget")
        .description("Shuffle through the words you learned.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
