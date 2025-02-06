//
//  ActionBuilder.swift
//  EazySwiftUI
//
//  Created by Elioene Silves Fernandes on 06/02/2025.
//

import SwiftUI

/// A result builder for constructing an array of `SwipeAction` instances.
///
/// This builder allows for the declarative creation of multiple `SwipeAction`
/// objects in a concise and readable manner.
///
/// Example usage:
/// ```swift
/// let actions = ActionBuilder {
///     SwipeAction(symbolImage: "trash", tint: .red, background: .black, action: { _ in })
///     SwipeAction(symbolImage: "pencil", tint: .blue, background: .gray, action: { _ in })
/// }
/// ```
@resultBuilder
struct ActionBuilder {
    
    /// Combines multiple `SwipeAction` instances into an array.
    /// - Parameter components: A variadic list of `SwipeAction` objects.
    /// - Returns: An array of `SwipeAction` objects.
    static func buildBlock(_ components: SwipeAction...) -> [SwipeAction] {
        return components
    }
}

struct ActionSwipeConfiguration {
    
    var leadingPadding: CGFloat = 0
    var trailingPadding: CGFloat = 10
    var spacing: CGFloat = 10
    var fullWidth: Bool = true
}

extension View {
    @ViewBuilder
    func swipeActions(
        _ configuration: ActionSwipeConfiguration = .init(),
        @ActionBuilder actions: () -> [SwipeAction]
    ) -> some View {
        self
            .modifier(SwipeActionsModifier(
                config: configuration,
                actions: actions()))
    }
}


fileprivate struct SwipeActionsModifier: ViewModifier {
    
    var sharedData = SwipeActionsObserverSharedData.shared
    @State private var activeID: String = UUID().uuidString
    
    var config: ActionSwipeConfiguration
    var actions: [SwipeAction]
    
    @State private var resetPositionTrigger: Bool = false
    @State private var offsetX: CGFloat = .zero
    @State private var progress: CGFloat = .zero
    @State private var bounceOffset: CGFloat = .zero
    @State private var lastStoredOffsetX: CGFloat = .zero
    
    @State private var currentScrollOffset: CGFloat = .zero
    @State private var storedCurrentScrollOffset: CGFloat?
    
    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .overlay {
                    Rectangle()
                        .foregroundStyle(.clear)
                        .containerRelativeFrame(config.fullWidth ? .horizontal : .init()) /// init creates an emption options set
                        .overlay(alignment: .trailing, content: ActionsView)
                }
                .compositingGroup()
                .offset(x: offsetX)
                .offset(x: bounceOffset)
                .mask {
                    Rectangle()
                        .containerRelativeFrame(config.fullWidth ? .horizontal : .init())
                }
                .gesture(
                    PanGesture(
                    onBegan: gestureDidBegan,
                    onChange: {gestureDidChange(translation: $0.translation)},
                    onEnded: { gestureDidEnd(translation: $0.translation, velocity: $0.velocity)}
                        )
                    )
                .onChange(of: resetPositionTrigger) { _ in
                    resetGesture()
                }
                .onGeometryChange(for: CGFloat.self) {
                    $0.frame(in:.scrollView).minY
                    
                } action: { newValue in
                    if let storedCurrentScrollOffset, storedCurrentScrollOffset != newValue {
                        resetGesture()
                    }
                }
                .onChange(of: sharedData.activeSwipeAction) {oldValue, newValue in
                    if newValue != activeID && offsetX != .zero {
                        resetGesture()
                    }
                }
        } else {
            // Fallback on earlier versions
        }
            
    }
    @ViewBuilder
     func ActionsView() -> some View {
        ZStack {
            ForEach(actions.indices, id: \.self) { index in
                
                let action = actions[index]
                
                GeometryReader { proxy in
                    
                    let size = proxy.size
                    let spacing = config.spacing * CGFloat(index)
                    let offset = (CGFloat(index) * size.width) + spacing
                    
                    Button(action:  { action.action(&resetPositionTrigger) }) {
                        Image(systemName:action.symbolImage)
                            .font(action.font)
                            .foregroundStyle(action.tint)
                            .frame(width: size.width, height: size.height)
                            .background(action.background, in: action.shape)
                    }
                    .offset(x: offset + progress)
                    
                }.frame(width: action.size.width, height: action.size.height)
            }
        }
        .visualEffect { content, proxy in
            content
                .offset(x: proxy.size.width)
        }
        .offset(x: config.leadingPadding)
    }
    
    /// Handles the beginning of a gesture by storing the current scroll offset
    /// and setting the active swipe action.
    private func gestureDidBegan() {
        /// Stores the current scroll position before the gesture starts.
        storedCurrentScrollOffset = lastStoredOffsetX
        
        /// Updates the shared active swipe action with the current action's identifier.
        sharedData.activeSwipeAction = activeID
    }

    /// Handles changes in the gesture by updating the horizontal offset,
    /// tracking the progress of the swipe, and applying a bounce effect.
    /// - Parameter translation: The current translation of the gesture.
    private func gestureDidChange(translation: CGSize) {
        /// Updates the horizontal offset based on the gesture translation.
        /// Ensures the offset remains within the allowed swipe bounds.
        offsetX = min(max(translation.width + lastStoredOffsetX, -maxOffsetWidth), 0)
        
        /// Calculates the progress of the swipe as a ratio of the total available swipe width.
        progress = offsetX / -maxOffsetWidth
        
        /// Applies a slight bounce effect when reaching swipe limits.
        bounceOffset = min(translation.width - (offsetX - lastStoredOffsetX), 0) / 10
    }

    /// Handles the end of a gesture by determining if the swipe should complete
    /// or return to the initial position based on velocity and final offset.
    /// - Parameters:
    ///   - translation: The final translation of the gesture.
    ///   - velocity: The velocity of the swipe at the end.
    private func gestureDidEnd(translation: CGSize, velocity: CGSize) {
        /// Calculates the target position based on the swipe velocity.
        let endTarget = velocity.width + offsetX
        
        withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
            
            /// If the swipe surpasses 60% of the allowed width, complete the action.
            if -endTarget > (maxOffsetWidth * 0.6) {
                offsetX = -maxOffsetWidth
                bounceOffset = .zero
                progress = 1
            } else {
                /// Otherwise, return to the initial position.
                resetGesture()
            }
        }
        
        /// Stores the final offset position after the animation.
        lastStoredOffsetX = offsetX
    }

    /// Resets the swipe gesture, returning the view to its initial position.
    private func resetGesture() {
        withAnimation(.spring()) {
            offsetX = .zero
            lastStoredOffsetX = .zero
            bounceOffset = .zero
            progress = .zero
        }
        
        /// Clears the stored scroll offset.
        storedCurrentScrollOffset = nil
    }

    /// Computes the maximum swipe offset width based on action button sizes and configuration.
    var maxOffsetWidth: CGFloat {
        /// Calculates the total width of all swipe actions.
        let totalActionSize: CGFloat = actions.reduce(.zero) { result, action in
            result + action.size.width
        }
        
        /// Computes the total spacing between actions.
        let spacing = config.spacing * CGFloat(actions.count - 1)
        
        /// Returns the total offset width including spacing and padding.
        return totalActionSize + spacing + config.leadingPadding + config.trailingPadding
    }
}


@MainActor
class SwipeActionsObserverSharedData {
    static let shared = SwipeActionsObserverSharedData()
    var activeSwipeAction: String?
}

#Preview {
    CustomSwipeActions()
        
}
