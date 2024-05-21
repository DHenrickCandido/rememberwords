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
import FirebaseAnalytics
import AppTrackingTransparency

@main
struct rememberWordsApp: App {
    @Environment(\.scenePhase) var scenePhase

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
            .onChange(of: scenePhase) { newValue in
                            if newValue == .active {
//                                requestDataPermission()
                            }
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
    
//    func requestDataPermission() {
//                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
//                    switch status {
//                    case .authorized:
//                        // Tracking authorization dialog was shown
//                        // and we are authorized
//                        Settings.shared.isAdvertiserTrackingEnabled = true
//                        Settings.shared.isAutoLogAppEventsEnabled = true
//                        Settings.shared.isAdvertiserIDCollectionEnabled = true
//                        print("Authorized")
//                    case .denied:
//                        // Tracking authorization dialog was
//                        // shown and permission is denied
//                        Settings.shared.isAdvertiserTrackingEnabled = false
//                        Settings.shared.isAutoLogAppEventsEnabled = false
//                        Settings.shared.isAdvertiserIDCollectionEnabled = false
//                        print("Denied")
//                    case .notDetermined:
//                        // Tracking authorization dialog has not been shown
//                        print("Not Determined")
//                    case .restricted:
//                        print("Restricted")
//                    @unknown default:
//                        print("Unknown")
//                    }
//                })
//          
//        }
    
    
}

