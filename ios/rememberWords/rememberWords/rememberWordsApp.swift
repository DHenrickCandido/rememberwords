//
//  rememberWordsApp.swift
//  rememberWords
//
//  Created by Diego Henrick on 25/09/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct rememberWordsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State var wordBank: [Word] = []
    var body: some Scene {
        WindowGroup {
            TabView {
                WordsView(selectedDeck: "English")
                    .tabItem {
                        Label("Menu", systemImage: "list.dash")
                    }

                WordShuffleView(wordsShuffle: wordBank)
                    .tabItem {
                        Label("Shuffle", systemImage: "shuffle")
                    }
            }.onAppear(){
                if let data = UserDefaults(suiteName: "group.com.diegohenrick.remember")?.data(forKey: "wordBank") {
                    if let loadedWordBank = try? JSONDecoder().decode([Word].self, from: data) {
                        wordBank = loadedWordBank
                    }
                }
            
        }
        }
    }
}

