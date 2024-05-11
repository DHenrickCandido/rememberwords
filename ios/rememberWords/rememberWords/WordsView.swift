//
//  HomeView.swift
//  rememberWords
//
//  Created by Diego Henrick on 30/09/23.
//

import SwiftUI

struct WordsView: View {
    @State var wordBank: [Word] = []
    @State var selectedDeck: String
    @State var showAddWord: Bool = false
    @State var selectedCard: Int = 0
    @State var selectedWord = Word(word: "", translation: "")
    @State private var navigateToSecondScreen = false

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
                        
                        CardView(word: word.word, translation: word.translation, wordBank: $wordBank, selectedWord: $selectedCard)
                            .padding(6)
                            .onTapGesture {
                                print("clicked")
                                selectedWord = word
                                self.navigateToSecondScreen = true

                            }
                    }
                }
                // NavigationLink que é ativado quando navigateToSecondScreen é true
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
                if let data = UserDefaults(suiteName: "group.com.diegohenrick.remember")?.data(forKey: "wordBank") {
                    if let loadedWordBank = try? JSONDecoder().decode([Word].self, from: data) {
                        wordBank = loadedWordBank
                    }
                }
            }
        }
    }
}

#Preview {
    WordsView(selectedDeck: "Portuguese")
}
