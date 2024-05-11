//
//  HomeView.swift
//  rememberWords
//
//  Created by Diego Henrick on 30/09/23.
//

import SwiftUI

struct HomeDecksView: View {
    @State var wordBank: [Word] = []
    var body: some View {
        ZStack {
            
            //Header (logo + mascote)
            VStack {
                ZStack (alignment: .leading) {
                    Rectangle()
                        .frame(height: 160)
                        .foregroundColor(Color("PurplePrimary"))
                    VStack{
                        
                        HStack () {
                            VStack{
                                Text("Decks")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .font(.largeTitle)
                                Text("Select a deck")
                                    .foregroundStyle(.white)
                                    .opacity(0.6)
                            }
                            Spacer()
                            
                            Image(systemName: "plus.app.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 32)
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 16)
                    }.padding(.top,32)

                }
                
                Spacer()
            }.ignoresSafeArea()
            //Fim do Header
        }
    }
}

#Preview {
    HomeDecksView()
}
