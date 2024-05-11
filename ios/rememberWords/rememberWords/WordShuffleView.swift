//
//  WordShuffleView.swift
//  rememberWords
//
//  Created by Diego Henrick on 06/12/23.
//

import SwiftUI

//struct WordShuffleView: View {
//    var wordsShuffle: [Word]
//    @State var isTurned: Bool = true
//    @State var showingIndex: Int = 0
//    
//    var body: some View {
//        VStack {
//            Spacer()
//            HStack {
//                Spacer()
//                Text(isTurned ? wordsShuffle[showingIndex].word : wordsShuffle[showingIndex].translation)
//                    .font(.title)
//                    .foregroundStyle(.black)
//                    .fontWeight(.semibold)
//                    .padding(.horizontal)
//                Spacer()
//            }
//            Spacer()
//            
//            Button(action: {
//                withAnimation {
//                    isTurned.toggle()
//                }
//            }, label: {
//                Text("Turn")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                    .foregroundStyle(.white)
//                    .font(.headline)
//                    .frame(maxWidth: 100)
//                    .frame(height: 48)
//                    .background(Color("GreenPrimary"))
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//                
//            }).padding(.bottom, 100)
//            
//        }
//        .background(){
//            Color("GreenSecondary")
//        }
//        .ignoresSafeArea()
//        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
//                            .onEnded({ value in
//                                if value.translation.width < 0 {
//                                    // left
//                                    if showingIndex < wordsShuffle.count-1 {
//                                        showingIndex += 1
//                                    }
//                                }
//
//                                if value.translation.width > 0 {
//                                    if showingIndex > 0 {
//                                        showingIndex -= 1
//                                    }
//                                }
//                                if value.translation.height < 0 {
//                                    // up
//                                }
//
//                                if value.translation.height > 0 {
//                                    // down
//                                }
//                            }))
//    }
//}

struct WordShuffleView: View {
    @State var wordsShuffle: [Word]
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
            if let data = UserDefaults(suiteName: "group.com.diegohenrick.remember")?.data(forKey: "wordBank") {
                if let loadedWordBank = try? JSONDecoder().decode([Word].self, from: data) {
                    wordsShuffle = loadedWordBank
                }
            }
        }
//        .background(Color("GreenSecondary"))
//        .ignoresSafeArea()
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


#Preview {
    WordShuffleView(wordsShuffle: [Word(word: "Hello", translation: "Ola"),Word(word: "Award", translation: "Premio")])
}
