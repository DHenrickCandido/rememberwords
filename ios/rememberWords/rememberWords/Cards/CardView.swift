//
//  CardView.swift
//  rememberWords
//
//  Created by Diego Henrick on 30/09/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct CardView: View {
    @State var id: String
    @State var word: String
    @State var translation: String
    @State var isTurned: Bool = true
    @Binding var wordBank: [WordNew]
    @Binding var selectedWord: Int
    
    @State var deckManager = DeckManager()
    
    var body: some View {
        VStack{
            HStack() {
                VStack(alignment: .center){
                    HStack{
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(.black)
                            .opacity(0.2)
                            .onTapGesture {
                                withAnimation {
                                    removeWord(id: id)
                                    
                                }
                            }
                        Spacer()
                    }.padding(.top, -4)
                    Spacer()
                    HStack{
                        Text(isTurned ? word : translation)
                            .font(.title3)
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                    }
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isTurned.toggle()
                        }
                    }, label: {
                        Text("Turn")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 32)
                            .background(Color("GreenPrimary"))
                            .cornerRadius(10)
                        
                    })
                    
                }

            }.padding(.horizontal)

        }
        .padding(.vertical, 16)
        .frame(width: 150, height: 180, alignment: .center)
        .background(Color("GreenSecondary"))
        .foregroundColor(.white)
        .cornerRadius(16)
        .rotation3DEffect(.degrees(isTurned ? 0 : 360), axis: (x: 0, y: 1, z: 0))
        .animation(.easeInOut, value: isTurned)
    }
    func deleteWord(id: String) {
        for i in 0..<wordBank.count {
            if wordBank[i].id == id {
                wordBank.remove(at: i)
                
                let randomWord = wordBank.randomElement()
//                UserDefaults.standard.set(false, forKey: "isButtonRandom")
//                UserDefaults.standard.set(false, forKey: "isButtonTurn")
                UserDefaults.standard.set(randomWord?.id ?? "", forKey: "RandomWord.id")
                UserDefaults.standard.set(randomWord?.word ?? "No Words", forKey: "RandomWord.word")
                UserDefaults.standard.set(randomWord?.translation ?? "No Words", forKey: "RandomWord.translation")
                UserDefaults.standard.set(false, forKey: "RandomWord.isTurned")
                UserDefaults.standard.synchronize()

                break
            }
        }
    }
    
    func removeWord(id: String) {
        deleteWord(id: id)

        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("Users").document(userID).collection("Deck").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }

    }
}

//#Preview {
//    CardView(word: "Olá", translation: "Hello", wordBank: $wordBank, selectedWord: $selectedCard)
//}
