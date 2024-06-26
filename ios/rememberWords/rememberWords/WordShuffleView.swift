//
//  WordShuffleView.swift
//  rememberWords
//
//  Created by Diego Henrick on 06/12/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

struct WordShuffleView: View {
    @State var wordsShuffle: [WordNew]
    @State var showingIndex: Int = 0
    
    @GestureState private var translation: CGSize = .zero
    @State private var dragState: DragState = .inactive
    
    var body: some View {
        let drag = DragGesture()
            .updating($translation) { value, state, _ in
                state = value.translation
            }
            .onEnded(onDragEnded)
        
        return VStack {
            Spacer()
            Text("SHUFFLE")
                .font(.title)
                .bold()
            Text("Swipe left to next card")
                .padding(.top, 8 )
                .font(.caption)

            Spacer()
            if !wordsShuffle.isEmpty {
                ZStack {
                    ForEach(wordsShuffle.indices.reversed(), id: \.self) { index in
                        WordView(word: wordsShuffle[index].word, translation: wordsShuffle[index].translation)
                            .offset(x: index == showingIndex ? translation.width : 0)
                            .zIndex(index == showingIndex ? 1 : 0)
                            .animation(.easeInOut)
                            .gesture(drag)
                    }
                }.padding(.bottom, 16)
            
            } else {
                Text("No words registered")
                    .opacity(0.8)
                    .font(.title2)
            }

            Spacer()
        }
        .onAppear(){
            fetchWords()
        }
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        let dragThreshold: CGFloat = 100
        let dragDistance = drag.translation.width
        
        if dragDistance > dragThreshold {
            if showingIndex > 0 {
                withAnimation {
                    showingIndex -= 1
                }
            }
        } else if dragDistance < -dragThreshold {
            if showingIndex < wordsShuffle.count - 1 {
                withAnimation {
                    showingIndex += 1
                }
            }
        }
    }
    
    func fetchWords() {
        wordsShuffle.removeAll()
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
                    wordsShuffle.append(wordCreated)
                }
            }
        }
    }
}

struct WordView: View {
    var word: String
    var translation: String
    @State var isTurned: Bool = false

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(isTurned ? translation : word)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                Spacer()
            }
            Spacer()
                Button(action: {
                    withAnimation {
                        isTurned.toggle()
                    }
                }, label: {
                    Text("Turn")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(maxWidth: 100)
                        .frame(height: 48)
                        .background(Color("GreenPrimary"))
                        .cornerRadius(10)
                        .padding(.horizontal)
    
                }).padding(.bottom, 100)
        }
        .frame(width: 350, height: 550)
        .background(Color("GreenSecondary"))
        .cornerRadius(20)
//        .shadow(color: .black, radius:0.1, x: 1, y: 1)
        .shadow(radius: 1)
    }
}

enum DragState {
    case inactive
    case dragging
}


//#Preview {
//    WordShuffleView(wordsShuffle: [Word(word: "Hello", translation: "Ola"),Word(word: "Award", translation: "Premio")])
//}
