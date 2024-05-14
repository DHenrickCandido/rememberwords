//
//  rememberWordsApp.swift
//  rememberWords
//
//  Created by Diego Henrick on 25/09/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import Firebase


@main
struct rememberWordsApp: App {
    
    init() {
        FirebaseApp.configure()
          do {
              try Auth.auth().useUserAccessGroup("\(teamID).com.candidohdiego.rememberWords")
          } catch {
              print(error.localizedDescription)
          }
    }
    @State var wordBank: [WordNew] = []
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
                anonymous()

            }
        }
    }
    
    func anonymous() {
        Auth.auth().signInAnonymously { authResult, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
        
        guard let userID = Auth.auth().currentUser?.uid else { return }

        if let suiteDefaults = UserDefaults(suiteName: "group.com.diegohenrick.remember") {
            suiteDefaults.set(userID, forKey: "userID")
        }
        
    }
}

