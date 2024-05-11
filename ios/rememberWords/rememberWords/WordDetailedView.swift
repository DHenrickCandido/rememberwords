//
//  WordDetailedView.swift
//  rememberWords
//
//  Created by Diego Henrick on 06/12/23.
//

import SwiftUI

struct WordDetailedView: View {
    var word: Word
    @State var isTurned: Bool = true
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(isTurned ? word.word : word.translation)
                    .font(.largeTitle)
                    .foregroundStyle(.black)
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
        .background(){
            Color("GreenSecondary")
        }
        .frame(width: 350, height: 650)
        .background(Color("GreenSecondary"))
        .cornerRadius(20)
        .shadow(radius: 4)
    }
}

#Preview {
    WordDetailedView(word: Word(word: "Hello", translation: "Ola"))
}
