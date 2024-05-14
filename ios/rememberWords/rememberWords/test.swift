//
//  test.swift
//  rememberWords
//
//  Created by Diego Henrick on 30/09/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

//struct test: View {
//    @State private var isDeleteMenuVisible = false
//
//    var body: some View {
//        ZStack {
//            // Your item content here
//            Text("Item")
//                .padding()
//                .background(Color.blue)
//                .cornerRadius(10)
//
//            if isDeleteMenuVisible {
//                Rectangle()
//                    .fill(Color.black.opacity(0.4))
//                    .ignoresSafeArea()
//
//                VStack {
//                    Text("Delete")
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.red)
//                        .cornerRadius(10)
//                }
//                .onTapGesture {
//                    // Handle delete action here
//                    // For example, you can show a confirmation dialog or delete the item directly
//                    // After deletion, set isDeleteMenuVisible to false to dismiss the menu
//                    isDeleteMenuVisible = false
//                }
//            }
//        }
//        .onLongPressGesture {
//            isDeleteMenuVisible = true
//        }
//        .animation(.easeInOut)
//    }
//}

struct test: View {
    @State private var wordsList: [WordNew] = []
    
    var body: some View {
        VStack {
            // Exibir os dados quando estiverem disponíveis
            if !wordsList.isEmpty {
                List(wordsList, id: \.id) { word in
                    Text(word.word)
                }
            } else {
                // Exibir um indicador de carregamento enquanto os dados estão sendo buscados
                ProgressView()
            }
        }
        .onAppear {
            fetchWords()
        }
    }
    
    func fetchWords() {
        wordsList.removeAll()
        let db = Firestore.firestore()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let ref = db.collection("Users").document(userID).collection("Deck")
        
        ref.getDocuments { snapshot, error in
            if let error = error {
                print("Erro ao buscar dados: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let id = data["id"] as? String ?? ""
                    let word = data["word"] as? String ?? ""
                    let translation = data["translation"] as? String ?? ""
                    
                    let wordCreated = WordNew(id: id, word: word, translation: translation)
                    wordsList.append(wordCreated)
                }
            }
        }
    }
}


#Preview {
    test()
}
