//
//  test.swift
//  rememberWords
//
//  Created by Diego Henrick on 30/09/23.
//

import SwiftUI

struct test: View {
    @State private var isDeleteMenuVisible = false

    var body: some View {
        ZStack {
            // Your item content here
            Text("Item")
                .padding()
                .background(Color.blue)
                .cornerRadius(10)

            if isDeleteMenuVisible {
                Rectangle()
                    .fill(Color.black.opacity(0.4))
                    .ignoresSafeArea()

                VStack {
                    Text("Delete")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .onTapGesture {
                    // Handle delete action here
                    // For example, you can show a confirmation dialog or delete the item directly
                    // After deletion, set isDeleteMenuVisible to false to dismiss the menu
                    isDeleteMenuVisible = false
                }
            }
        }
        .onLongPressGesture {
            isDeleteMenuVisible = true
        }
        .animation(.easeInOut)
    }
}


#Preview {
    test()
}
