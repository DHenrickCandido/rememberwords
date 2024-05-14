//
//  HomeView.swift
//  rememberWords
//
//  Created by Diego Henrick on 30/09/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

struct WordsView: View {
    @State var wordBank: [WordNew] = []
    @State var selectedDeck: String
    @State var showAddWord: Bool = false
    @State var selectedCard: Int = 0
    @State var selectedWord = WordNew(id: "", word: "", translation: "")
    @State private var navigateToSecondScreen = false
    
    @State var deckManager = DeckManager()
    
    var body: some View {
        NavigationStack{
            VStack {
                HStack () {
                    VStack(alignment: .leading){
                        Text("Words")
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                        Text("Save the words you learned!")
                            .foregroundStyle(.white)
                            .opacity(0.6)
                    }
                    Spacer()
                    
                    
                    Button (action: {
                        showAddWord.toggle()
                        
                    }, label: {
                        Image(systemName: "plus.app.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 24)
                            .foregroundStyle(.white)
                        
                    })
                    
                }
                
                .padding(16)
            }
            .background(Color("PurplePrimary"))
            
            ScrollView{
                
                LazyVGrid(columns: [GridItem(.flexible(minimum: 0, maximum: .infinity)), GridItem(.flexible(minimum: 0, maximum: .infinity))]) {
                    ForEach(wordBank) { word in
                        
                        CardView(id: word.id, word: word.word, translation: word.translation, wordBank: $wordBank, selectedWord: $selectedCard)
                            .padding(6)
                            .onTapGesture {
                                print("clicked")
                                selectedWord = word
                                self.navigateToSecondScreen = true

                            }
                    }
                }
                NavigationLink(destination: WordDetailedView(word: selectedWord), isActive: $navigateToSecondScreen) {
                    EmptyView() // Use EmptyView() como o conteúdo, pois não precisamos de nenhum conteúdo visível aqui
                }
                
            }
            .padding()
            .sheet(isPresented: $showAddWord){
                NewWordView(showAddWord: $showAddWord, wordBank: $wordBank)
                    .presentationDetents([.fraction(0.7)])
                    .interactiveDismissDisabled()
            }
            .onAppear(){
                fetchWords()
            }
        }
    }
    
    func fetchWords() {
        wordBank.removeAll()
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
                    wordBank.append(wordCreated)
                }
            }
        }
    }
}

#Preview {
    WordsView(selectedDeck: "Portuguese")
}
