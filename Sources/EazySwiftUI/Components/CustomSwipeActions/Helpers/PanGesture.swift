//
//  PanGesture.swift
//  EazySwiftUI
//
//  Created by Elioene Silves Fernandes on 06/02/2025.
//

import SwiftUI

/// A structure representing the value of a pan gesture, including translation and velocity.
struct PanGestureValue {
    
    /// The current translation of the gesture in size coordinates.
    var translation: CGSize = .zero
    
    /// The current velocity of the gesture in size coordinates.
    var velocity: CGSize = .zero
}

@available(iOS 18, *)
/// A custom pan gesture recognizer that provides gesture updates through closures.
struct PanGesture: UIGestureRecognizerRepresentable {
    
    /// A closure executed when the gesture begins.
    var onBegan: () -> Void
    
    /// A closure executed when the gesture changes.
    /// - Parameter value: The current translation and velocity of the gesture.
    var onChange: (PanGestureValue) -> Void
    
    /// A closure executed when the gesture ends or is canceled.
    /// - Parameter value: The final translation and velocity of the gesture.
    var onEnded: (PanGestureValue) -> Void
    
    /// Creates and configures a `UIPanGestureRecognizer` instance.
    /// - Parameter context: The context containing information for the gesture.
    /// - Returns: A configured `UIPanGestureRecognizer`.
    func makeUIGestureRecognizer(context: Context) -> some UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer()
        gesture.delegate = context.coordinator
        return gesture
    }
    
    /// Updates the existing `UIPanGestureRecognizer` as needed.
    /// - Parameters:
    ///   - recognizer: The gesture recognizer being updated.
    ///   - context: The SwiftUI context.
    func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
        // No updates needed in this implementation.
    }
    
    /// Creates a coordinator to manage gesture recognition behavior.
    /// - Parameter converter: A coordinate space converter (not currently used).
    /// - Returns: A `Coordinator` instance.
    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        Coordinator()
    }
    
    /// Handles the pan gesture state changes and calls appropriate closures.
    /// - Parameters:
    ///   - recognizer: The gesture recognizer handling the pan action.
    ///   - context: The SwiftUI context.
    func handleUIGestureRecognizerAction(_ recognizer: UIGestureRecognizerType, context: Context) {
        let state = recognizer.state
        let translation = recognizer.translation(in: recognizer.view).toSize
        let velocity = recognizer.velocity(in: recognizer.view).toSize
        
        let gestureValue = PanGestureValue(translation: translation, velocity: velocity)
        
        switch state {
        case .began:
            onBegan()
        case .changed:
            onChange(gestureValue)
        case .ended, .cancelled:
            onEnded(gestureValue)
        default:
            break
        }
    }
    
    /// A coordinator class to handle gesture recognition behavior.
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        
        /// Restricts gesture recognition to primarily horizontal movements.
        /// - Parameter gestureRecognizer: The gesture recognizer being evaluated.
        /// - Returns: `true` if the gesture should begin, `false` otherwise.
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
                let velocity = panGesture.velocity(in: panGesture.view)
                return abs(velocity.x) > abs(velocity.y)
            }
            return false
        }
    }
}

extension CGPoint {
    /// Converts a `CGPoint` to `CGSize`, using `x` as width and `y` as height.
    var toSize: CGSize {
        return CGSize(width: x, height: y)
    }
}
