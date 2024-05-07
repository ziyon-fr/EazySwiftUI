//
//  WiggleAnimation.swift
//  
//
//  Created by Elioene Silves Fernandes on 07/05/2024.
//

import SwiftUI

/// Adds a wiggle effect to the view, making it shake or wiggle.
public extension View {
    /// Adds a wiggle effect to the view with customisable parameters.
    ///
    /// - Parameters:
    ///   - animatableData: The data driving the animation.
    ///   - direction: The axis along which the view wiggles. Default is `.horizontal`.
    ///   - distance: The distance the view moves during the wiggle animation. Default is `10`.
    ///   - shakesPerUnit: The number of shakes per unit of animatable data. Default is `3`.
    /// - Returns: A view modified with the wiggle effect.
    @ViewBuilder
    func wiggle(
        animatableData: CGFloat,
        direction: Axis = .horizontal,
        distance: CGFloat = 10,
        shakesPerUnit: Int = 3
    ) -> some View {
        modifier(WiggleAnimation(
            animatableData: animatableData,
            direction: direction,
            distance: distance,
            shakesPerUnit: shakesPerUnit
        ))
    }

    /// Adds a wiggle effect to the view with a boolean flag to trigger animation.
    ///
    /// - Parameter animate: A boolean flag indicating whether to animate the wiggle effect.
    /// - Returns: A view modified with the wiggle effect.
    @available(iOS 17.0, *)
    @ViewBuilder
    func wiggle(_ animate: Bool) -> some View {
        self
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: animate) { view, value in
                view
                    .offset(x: value)
            } keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(0, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(0, duration: 0.1)
                }
            }
    }
}

/// A geometry effect that adds a wiggle animation to the view.
struct WiggleAnimation: GeometryEffect {
    var animatableData: CGFloat
    var direction: Axis
    var distance: CGFloat = 5
    var shakesPerUnit: Int = 200

    /// Applies the wiggle animation to the view.
    ///
    /// - Parameter size: The size of the view.
    /// - Returns: A projection transform to apply the wiggle animation.
    func effectValue(size: CGSize) -> ProjectionTransform {
        switch direction {
        case .horizontal:
            return ProjectionTransform(CGAffineTransform(
                translationX: distance * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                y: 0
            ))
        case .vertical:
            return ProjectionTransform(CGAffineTransform(
                translationX: 0,
                y: distance * sin(animatableData * .pi * CGFloat(shakesPerUnit))
            ))
        }
    }
}

//MARK: Preview -
#Preview {
    StatefulPreview(CGFloat.zero) { attempts in
        NavigationStack {
            VStack(alignment: .leading, spacing: 40) {
                Text("Horizontal Wiggle Example")
                    .wiggle(animatableData: attempts.wrappedValue)
                
                Text("Vertical Wiggle Example")
                    .wiggle(animatableData: attempts.wrappedValue, direction: .vertical)
                
                Text("Large Distance Wiggle Example")
                    .wiggle(animatableData: attempts.wrappedValue, distance: 80)
                
                Text("Large amount of Wiggle Example")
                    .wiggle(animatableData: attempts.wrappedValue, shakesPerUnit: 40)
                
                Button {
                    withAnimation(.default) {
                        attempts.wrappedValue += 1
                    }
                } label: {
                    Text("Wiggle")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.black, in: .rect(cornerRadius: 10))
                        .foregroundStyle(.white)
                       
                }
            }
            .padding(.horizontal)
            .navigationTitle("Wiggle Effect")
        }
    }
}
