//
//  BlurView.swift
//  
//
//  Created by Elioene Silves Fernandes on 07/05/2024.
//

import SwiftUI

/// A struct that represents a blur view, conforming to `UIViewRepresentable`.
public struct BlurView: UIViewRepresentable {
    /// The style of the blur effect.
    var style: UIBlurEffect.Style

    /// Creates the `UIVisualEffectView` with the specified blur effect style.
    ///
    /// - Parameter context: The context for coordinating with the SwiftUI runtime.
    /// - Returns: A `UIVisualEffectView` with the specified blur effect.
    public func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }

    /// Updates the `UIVisualEffectView` when the SwiftUI view hierarchy changes.
    ///
    /// - Parameters:
    ///   - uiView: The view being updated.
    ///   - context: The context for coordinating with the SwiftUI runtime.
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {

    }
}

struct BlurViewPreview: View {
    
    private let minHeight: CGFloat = 200
    private let defaultPadding: CGFloat = 40
    
    var body: some View {
        NavigationStack {
            ZStack {
                                
                VStack(spacing: defaultPadding) {
                    
                    Circle()
                        .fill(.purple)
                        .frame(minHeight: minHeight)
                    
                    HStack(spacing: defaultPadding) {
                        Circle()
                            .fill(.orange)
                            .frame(height: minHeight)
                        Circle()
                            .fill(.blue)
                            .frame(height: 100)
                    }
                }
                .padding()
                
                BlurView(style: .systemUltraThinMaterialLight)
                    .ignoresSafeArea()
            }
            .navigationTitle("Blur View")
        }
    }
}

#Preview {
    BlurViewPreview()
}
