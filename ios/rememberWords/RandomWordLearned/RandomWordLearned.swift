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
    func placeholder(in context: Context) -> SimpleEntry {
        var isTurned = false
        var selectedWordNova = WordNew(id: "", word: "No Words", translation: "No Words")

        return SimpleEntry(date: Date(), selectedWordEntry: selectedWordNova, isTurned: isTurned)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let db = Firestore.firestore()
        var isTurned = false
        var selectedWordNova = WordNew(id: "", word: "No Words", translation: "No Words")

        let entry = SimpleEntry(date: Date(), selectedWordEntry: selectedWordNova, isTurned: isTurned)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        
        let isButtonPressed = UserDefaults.standard.bool(forKey: "isButtonPressed")
        
        if isButtonPressed == false || isButtonPressed == nil {
            print("TEST CUUUU")
            let db = Firestore.firestore()

            guard let userID = Auth.auth().currentUser?.uid else { return }

            let ref = db.collection("Users").document(userID).collection("Deck")

            ref.getDocuments { snapshot, error in
                if let snapshot = snapshot {
                    var wordsList: [WordNew] = []

                    for document in snapshot.documents {
                        let data = document.data()

                        let id = data["id"] as? String ?? ""
                        let word = data["word"] as? String ?? ""
                        let translation = data["translation"] as? String ?? ""

                        let wordCreated = WordNew(id: id, word: word, translation: translation)
                        wordsList.append(wordCreated)
                    }

                    if !wordsList.isEmpty {
                        let randomIndex = Int.random(in: 0..<wordsList.count)
                        let randomWord = wordsList[randomIndex]

                        let randomWordRef = db.collection("Users").document(userID).collection("SelectedWord").document("word")
                        randomWordRef.setData(["id": randomWord.id, "word": randomWord.word, "translation": randomWord.translation, "isTurned": false]) { error in
                            if let error = error {
                                print("Error adding random word: \(error)")
                            } else {
                                print("Random word added successfully")
                            }
                        }
                    }
                } else {
                    print("Error getting documents: \(error)")
                }
            }
            
            guard let userID = Auth.auth().currentUser?.uid else { return }
            
            let docRef = db.collection("Users").document(userID).collection("SelectedWord").document("word")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    let id = data?["id"] as? String ?? ""
                    let word = data?["word"] as? String ?? ""
                    let translation = data?["translation"] as? String ?? ""
                    let isTurned = data?["isTurned"] as? Bool ?? false
                    let wordCreated = WordNew(id: id, word: word, translation: translation)
                    
                    let entry = SimpleEntry(date: Date(), selectedWordEntry: wordCreated, isTurned: isTurned)
                    entries.append(entry)
                    
                } else {
                    print("Document does not exist")
                }
                let timeline = Timeline(entries: entries, policy: .after(Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!))
                completion(timeline)
            }

            
        } else {
            UserDefaults.standard.set(false, forKey: "isButtonPressed")

            let db = Firestore.firestore()
            
            guard let userID = Auth.auth().currentUser?.uid else { return }
            
            let docRef = db.collection("Users").document(userID).collection("SelectedWord").document("word")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    let id = data?["id"] as? String ?? ""
                    let word = data?["word"] as? String ?? ""
                    let translation = data?["translation"] as? String ?? ""
                    let isTurned = data?["isTurned"] as? Bool ?? false
                    let wordCreated = WordNew(id: id, word: word, translation: translation)
                    
                    let entry = SimpleEntry(date: Date(), selectedWordEntry: wordCreated, isTurned: isTurned)
                    entries.append(entry)
                    
                } else {
                    print("Document does not exist")
                }
                let timeline = Timeline(entries: entries, policy: .after(Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!))
                completion(timeline)
            }
        }
        
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

struct WorkoutModel {
    var word: WordNew
    var isTurned: Bool
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
