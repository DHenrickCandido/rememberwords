//
//  RandomWordLearned.swift
//  RandomWordLearned
//
//  Created by Diego Henrick on 25/09/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        if loadWordSelected() == nil || loadWordSelected()! == ["","","",""] {
            var wordSelectedNil = ["","","","false"]
            let data = try? JSONEncoder().encode(wordSelectedNil)
            // Use UserDefaults com o suiteName
            if let suiteDefaults = UserDefaults(suiteName: "group.com.diegohenrick.remember") {
                suiteDefaults.set(data, forKey: "wordSelected")
            }
        }
        print(loadWordSelected())
        print("CUUU \(loadWordSelected())")
        let wordBankUD = loadWordBank()
        var wordSelected = loadWordSelected()
        print("CUUU \(wordSelected![3])")

        if wordSelected![3] == "true" {
            wordSelected![3] = "false"
            
            let data = try? JSONEncoder().encode(wordSelected)
            // Use UserDefaults com o suiteName
            if let suiteDefaults = UserDefaults(suiteName: "group.com.diegohenrick.remember") {
                suiteDefaults.set(data, forKey: "wordSelected")
            }
            
            return SimpleEntry(date: Date(), wordBank: wordBankUD, randomWord: Word(word: wordSelected![0], translation: wordSelected![1]), isTurned: wordSelected![2])

            
        }
        else {
            return SimpleEntry(date: Date(), wordBank: wordBankUD, randomWord: wordBankUD?.randomElement(), isTurned: wordSelected![2])
            
        }
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        if loadWordSelected() == nil || loadWordSelected()! == ["","","",""] {
            var wordSelectedNil = ["","","","false"]
            let data = try? JSONEncoder().encode(wordSelectedNil)
            // Use UserDefaults com o suiteName
            if let suiteDefaults = UserDefaults(suiteName: "group.com.diegohenrick.remember") {
                suiteDefaults.set(data, forKey: "wordSelected")
            }
        }
        
        let wordBankUD = loadWordBank()
        
        var wordSelected = loadWordSelected()
        print("CUUU \(wordSelected![3])")
        print(wordSelected![3])
        if wordSelected![3] == "true" {
            let entry = SimpleEntry(date: Date(), wordBank: wordBankUD, randomWord: Word(word: wordSelected![0], translation: wordSelected![1]), isTurned: wordSelected![2])
            wordSelected![3] = "false"
            
            let data = try? JSONEncoder().encode(wordSelected)
            // Use UserDefaults com o suiteName
            if let suiteDefaults = UserDefaults(suiteName: "group.com.diegohenrick.remember") {
                suiteDefaults.set(data, forKey: "wordSelected")
            }
            
            completion(entry)
        }
        else {
            let entry = SimpleEntry(date: Date(), wordBank: wordBankUD, randomWord: wordBankUD?.randomElement(), isTurned: wordSelected![2])
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        if loadWordSelected() == nil || loadWordSelected()! == ["","","",""] {
            var wordSelectedNil = ["","","","false"]
            let data = try? JSONEncoder().encode(wordSelectedNil)
            // Use UserDefaults com o suiteName
            if let suiteDefaults = UserDefaults(suiteName: "group.com.diegohenrick.remember") {
                suiteDefaults.set(data, forKey: "wordSelected")
            }
        }
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
                
        let wordBankUD = loadWordBank()
        
        
        var wordSelected = loadWordSelected()
        print("CUUU \(wordSelected![3])")

        if wordSelected![3] == "true" {
            let entry = SimpleEntry(date: Date(), wordBank: wordBankUD, randomWord: Word(word: wordSelected![0], translation: wordSelected![1]), isTurned: wordSelected![2])
            wordSelected![3] = "false"
            
            let data = try? JSONEncoder().encode(wordSelected)
            // Use UserDefaults com o suiteName
            if let suiteDefaults = UserDefaults(suiteName: "group.com.diegohenrick.remember") {
                suiteDefaults.set(data, forKey: "wordSelected")
            }
            
            entries.append(entry)
            
            
        }
        else {
            let entry = SimpleEntry(date: Date(), wordBank: wordBankUD, randomWord: wordBankUD?.randomElement(), isTurned: wordSelected![2])
            entries.append(entry)
        }
        
        
        let timeline = Timeline(entries: entries, policy: .after(Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!))
        completion(timeline)
    }
    
    func loadWordBank() -> [Word]? {
        if let data = UserDefaults(suiteName: "group.com.diegohenrick.remember")?.data(forKey: "wordBank") {
            if let loadedWordBank = try? JSONDecoder().decode([Word].self, from: data) {
                return loadedWordBank
            }
        }
        
        return nil
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

struct SimpleEntry: TimelineEntry {
    let date: Date
    let wordBank: [Word]?
    let randomWord: Word?
    let isTurned: String
    
}

struct RandomWordLearnedEntryView : View {
    @State var entry: Provider.Entry
    @State var test: Bool = true
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        @State var randomWord = entry.wordBank?.randomElement()
        @State var isTurned: String = entry.isTurned ?? "true"
        @State var word: String = randomWord?.word ?? ""
        @State var translation: String = randomWord?.translation ?? ""
        
        switch widgetFamily {
        case .systemSmall:
            VStack(){
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
                Text(isTurned == "true" ? entry.randomWord?.word ?? "No words" : entry.randomWord?.translation ?? "No words")
                    .font(.title3)
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .contentTransition(.opacity)
                    .invalidatableContent()
                    .padding(.top, 8)
                
                Spacer()
                Spacer()
                //                    Button(intent: ToggleStateIntent(isTurned: isTurned)) {
                
                //                    }
                Button(intent: ToggleStateIntent(word: entry.randomWord?.word ?? "No words", translation: entry.randomWord?.translation ?? "No words", isTurned: entry.isTurned, buttonActed: "true")) {
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
            VStack(){
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
                    Text(isTurned == "true" ? entry.randomWord?.word ?? "No words" : entry.randomWord?.translation ?? "No words")
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
                //                    Button(intent: ToggleStateIntent(isTurned: isTurned)) {
                
                //                    }
                Button(intent: ToggleStateIntent(word: entry.randomWord?.word ?? "No words", translation: entry.randomWord?.translation ?? "No words", isTurned: entry.isTurned, buttonActed: "true")) {
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

struct RandomWordLearned: Widget {
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

//struct RandomWordLearned_Previews: PreviewProvider {
//    static var previews: some View {
//        let wordBank = [Word(word: "test", translation: "teste"),Word(word: "OIE", translation: "teste"), Word(word: "TCHAUUU", translation: "teste"), Word(word: "POGGERS", translation: "teste")]
//        RandomWordLearnedEntryView(entry: SimpleEntry(date: Date(), wordBank: wordBank, randomWord: wordBank.randomElement()?.word ?? "deu ruim"))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//
//    }
//}
