//
//  CardView.swift
//  rememberWords
//
//  Created by Diego Henrick on 30/09/23.
//

import SwiftUI

struct CardView: View {
    @State var word: String
    @State var translation: String
    @State var isTurned: Bool = true
    @Binding var wordBank: [Word]
    @Binding var selectedWord: Int
    
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
                                    //                                wordBank.remove(at: selectedWord)
                                    wordBank.removeAll { $0 == Word(word: word, translation: translation) }
                                    let data = try? JSONEncoder().encode(wordBank)
                                    
                                    // Use UserDefaults com o suiteName
                                    if let suiteDefaults = UserDefaults(suiteName: "group.com.diegohenrick.remember") {
                                        suiteDefaults.set(data, forKey: "wordBank")
                                    }
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
//                            .padding(.vertical)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
//                            .frame(height: 120)
//                        Spacer()
                    }

                        
//                    Spacer()
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
//                            .padding(.horizontal)
                        
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
}

//#Preview {
//    CardView(word: "Olá", translation: "Hello", wordBank: $wordBank, selectedWord: $selectedCard)
//}
