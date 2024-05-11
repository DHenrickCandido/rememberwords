//
//  DeckCardView.swift
//  rememberWords
//
//  Created by Diego Henrick on 30/09/23.
//

import SwiftUI

struct DeckCardView: View {
    @State var name: String
    @State var qtdWords: Int
    var body: some View {
        VStack{
            HStack() {
                Image(systemName: "menucard.fill")
                    .foregroundStyle(Color("GreenPrimary"))
                    .font(.largeTitle)
                VStack(alignment: .leading){
                    Text(name.uppercased())
                        .font(.title3)
                        .foregroundStyle(.black)
                        .fontWeight(.black)
                        .padding(.horizontal)
                    
                    Text("\(qtdWords) words")
                        .foregroundStyle(.black)
                        .padding(.horizontal)
                    
                }

                Spacer()
            }.padding()

        }
        .padding(.vertical, 16)
        .frame(width: 320, height: 100, alignment: .center)
        .background(Color("GreenSecondary"))
        .foregroundColor(.white)
        .cornerRadius(16)
    }
}

#Preview {
    DeckCardView(name: "Portuguese", qtdWords: 2)
}
