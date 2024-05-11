//
//  AddWordView.swift
//  rememberWords
//
//  Created by Diego Henrick on 30/09/23.
//

import SwiftUI

struct Example_test2: View {
    @State var showAddDeck: Bool = false
    
    var body: some View {
        Button("click me") {
            showAddDeck.toggle()
        }
        .sheet(isPresented: $showAddDeck){
            NewDeckView(showAddDeck: $showAddDeck)
                .presentationDetents([.fraction(0.7)])
                .interactiveDismissDisabled()
        }

    }
}

struct NewDeckView: View {
    @Binding var showAddDeck: Bool
    @State var name: String = ""
//    @Binding var
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40){
            
            ZStack {
                
                HStack {
                    Image(systemName: "xmark")
                        .fontWeight(.bold)
                        .onTapGesture {
                            showAddDeck.toggle()
                        }
                    
                    Spacer()
                    
                    Text("")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                }
                
                Text("Add new deck")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
            }

            VStack (alignment: .leading) {
                Text("Deck name:")
                    .font(.headline)
                    .bold()
                
                HStack(alignment: .top, spacing: 10) {
                    TextField("Type the language name", text: $name)
                        .font(.callout)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(Color("GreenSecondary"))
                        .cornerRadius(8)
                }
                
                
            }
            Spacer()
            
            HStack {
                

                Spacer()
                Text("Add")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 340, height: 54)
                    .background(Color("GreenPrimary"))
                    .cornerRadius(8)
                    .onTapGesture {
                        showAddDeck.toggle()
                    }
                
                Spacer()
            }
        }.padding(16)
    }
    
}

#Preview {
    Example_test2()
}
