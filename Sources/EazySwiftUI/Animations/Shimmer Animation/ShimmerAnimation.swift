//
//  ShimmerAnimation.swift
//  
//
//  Created by Elioene Silves Fernandes on 07/05/2024.
//

import SwiftUI

/// Adds a shimmer effect to the view, creating a flickering appearance like a reflection.
public extension View {
    /// Adds a shimmer effect to the view with customisable parameters.
    ///
    /// - Parameters:
    ///   - color: The base color of the shimmer effect.
    ///   - highlight: The highlight colour of the shimmer effect.
    ///   - blur: The amount of blur applied to the shimmer. Default is `0`.
    ///   - speed: The speed of the shimmer animation. Default is `2`.
    ///   - blendingMode: The blending mode to apply to the shimmer effect. Default is `.normal`.
    /// - Returns: A view modified with the shimmer effect.
    @ViewBuilder
    func shimmer(
        color: Color,
        highlight: Color,
        blur: CGFloat = .zero,
        speed: CGFloat = 2,
        blendingMode: BlendMode = .normal
    ) -> some View {
        self.modifier(ShimmerEffectModifier(
            color: color,
            highlight: highlight,
            blur: blur,
            speed: speed,
            blendingMode: blendingMode
        ))
    }
}

/// A view modifier that adds a shimmer effect to the view.
struct ShimmerEffectModifier: ViewModifier {
    @State private var moveTo: CGFloat = -0.7 // Initial value to start the shimmer animation.

    var color: Color
    var highlight: Color
    var blur: CGFloat
    var speed: CGFloat
    var blendingMode: BlendMode

    /// Applies the shimmer effect to the view.
    ///
    /// - Parameter content: The content view to be shimmered.
    /// - Returns: A view with the shimmer effect applied.
    func body(content: Content) -> some View {
        content
            .hidden() // Hides the content view.
            .overlay { // Adds an overlay to the content view.
                Rectangle()
                    .fill(color)
                    .mask { content } // Masks the content view with a rectangle filled with the base color.
                    .overlay { // Creates the shimmer effect overlay.
                        GeometryReader { proxy in
                            let size = proxy.size
                            let extraOffset = (size.height / 2.5) + blur

                            Rectangle()
                                .fill(highlight)
                                .mask { // Masks the shimmer effect rectangle.
                                    Rectangle()
                                        .fill(
                                            .linearGradient(
                                                colors: [
                                                    .white.opacity(0),
                                                    highlight,
                                                    .white.opacity(0)
                                                ],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .blur(radius: blur) // Applies blur to the shimmer effect.
                                        .rotationEffect(.init(degrees: -70)) // Rotates the shimmer effect.
                                        .offset(x: moveTo > 0 ? extraOffset : -extraOffset) // Offsets the shimmer effect.
                                        .offset(x: size.width * moveTo) // Moves the shimmer effect.
                                }
                                .blendMode(blendingMode) // Applies the blending mode.
                        }
                        .mask { content } // Masks the shimmer effect with the content view.
                    }
                    .onAppear { // Triggers the shimmer animation when the view appears.
                        DispatchQueue.main.async { // Ensures the animation occurs on the main thread.
                            moveTo = 0.7 // Moves the shimmer effect from start to end.
                        }
                    }
                    .animation( // Applies the animation to the shimmer effect.
                        .linear(duration: speed).repeatForever(autoreverses: false),
                        value: moveTo
                    )
            }
    }
}
//MARK: - Preview
#Preview {
    NavigationStack {
        ScrollView {
            VStack(alignment: .leading) {
                
                Text("Shimmer Effect")
                    .shimmer(color: .blue, highlight: .cyan)
                
                HStack {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 50))
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 50, alignment: .center)
                        
                }.shimmer(color: .gray, highlight: .white.opacity(0.5))
                
                HStack {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 50))
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 50, alignment: .center)
                        
                }.shimmer(color: .gray, highlight: .white.opacity(0.5))
                
                HStack {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 50))
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 50, alignment: .center)
                        
                }.shimmer(color: .gray, highlight: .white.opacity(0.5))
                
            }
            .padding()
            .navigationTitle("Shimmer Effect")
            .frame(maxHeight: .infinity, alignment: .topLeading)
        .preferredColorScheme(.dark)
        }
    }
}
