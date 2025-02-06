//
//  CustomSwipeActions.swift
//  EazySwiftUI
//
//  Created by Elioene Silves Fernandes on 06/02/2025.
//

import SwiftUI

struct CustomSwipeActions: View {
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("Swipe left to trigger the action <-")
                RoundedRectangle(cornerRadius: 10)
                    .fill(.black.gradient)
                    .frame(height: 50)
                    .swipeActions {
                        SwipeAction(
                            symbolImage: "heart.fill",
                            tint: .red,
                            background: .blue) { resetPositon in
                                print("Button one tapped")
                                resetPositon.toggle()
                            }
                        
                        SwipeAction(
                            symbolImage: "star.fill",
                            tint: .yellow,
                            background: .brown) { resetPositon in
                                print("Button two tapped")
                                resetPositon.toggle()
                            }
                    }
            }
            .padding(15)
            .navigationTitle("Custom Swipe Actions")
        }
    }
}

#Preview {
    CustomSwipeActions()
}
