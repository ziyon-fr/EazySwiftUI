//
//  RectPreferenceKey.swift
//  EazySwiftUI
//
//  Created by Leon Salvatore on 30.03.2026.
//


//
//  ExtensionView.swift
//  CONVIVA
//
//  Created by Leon Salvatore on 26.12.2025.
//


import SwiftUI

extension View {

    @ViewBuilder
    func debugEnvironment() -> some View {
        self
           
            .environment(PlaylistObserver())
            .environment(PresenceManager.shared)
            .environment(AuthenticationService())
            .environment(MusiciansObserver())
            .environment(SettingsObserver())
            .environment(SessionStore())
            .environment(NotificationManager())
            .environment(AudioPlayerManager())
            .environment(AudioCacheManager.shared)
            .environment(SaturdayEventsObserverHandle())
            .environment(SongDocumentObserver(provider: MockSongProvider(),associateID: ""))
            .environment(SongsObserver())
            .environment(CreateSongObserver(song: .mock[0]))
    }

    @ViewBuilder
    func removeView(if condition: Bool, transition: (any Transition)? = nil) -> some View {
        if condition { EmptyView() }
        else { self }
    }


    /// Conditional modifier application
    @ViewBuilder
    func applyIf(_ condition: Bool, transform: (Self) -> some View) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}


fileprivate struct RectPreferenceKey: PreferenceKey {

   static var defaultValue: CGRect = .zero

   static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
       value = nextValue()
   }
}

// MARK: - Edge-Based Transitions
extension AnyTransition {
    /// Slide in/out from bottom
    static var slideFromBottom: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom),
            removal: .move(edge: .bottom)
        )
    }

    /// Slide in/out from top
    static var slideFromTop: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .top),
            removal: .move(edge: .top)
        )
    }

    /// Slide in/out from leading (left)
    static var slideFromLeading: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .leading),
            removal: .move(edge: .leading)
        )
    }

    /// Slide in/out from trailing (right)
    static var slideFromTrailing: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .trailing)
        )
    }

    /// Scale in/out
    static var scaleAndFade: AnyTransition {
        .asymmetric(
            insertion: .scale.combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }

    /// Custom edge-based transition
    static func slide(from edge: Edge, insertion: Bool = true, removal: Bool = true) -> AnyTransition {
        var insertionTransition: AnyTransition = .identity
        var removalTransition: AnyTransition = .identity

        if insertion {
            insertionTransition = .move(edge: edge)
        }
        if removal {
            removalTransition = .move(edge: edge)
        }

        return .asymmetric(
            insertion: insertionTransition,
            removal: removalTransition
        )
    }
}

// MARK: - Remove View with Transition
extension View {
    /// Removes the view with a transition when condition is true
    @ViewBuilder
    func removeView(
        if condition: Bool,
        transition: AnyTransition = .opacity,
        duration: Double = 0.3,
        removalEdge: Edge? = nil
    ) -> some View {
        var finalTransition: AnyTransition = .opacity
        if let edge = removalEdge {
            finalTransition = .asymmetric(
                insertion: .identity,
                removal: .move(edge: edge)
            )
        } else {
            finalTransition = .asymmetric(
                insertion: .identity,
                removal: transition
            )
        }

        self
            .transition(finalTransition)
            .animation(.easeInOut(duration: duration), value: condition)
            .applyIf(condition) { view in
                view.hidden()
                    .frame(height: 0)
                    .padding(.zero)
                    .clipped()
            }
    }

    /// Advanced removal with full control over insertion/removal transitions
    @ViewBuilder
    func removeView(
        if condition: Bool,
        insertion: AnyTransition = .identity,
        removal: AnyTransition = .opacity,
        animation: Animation = .easeInOut(duration: 0.3)
    ) -> some View {
        self
            .transition(.asymmetric(insertion: insertion, removal: removal))
            .animation(animation, value: condition)
            .applyIf(condition) { view in
                view.hidden()
                    .frame(width: 0, height: 0)
                    .padding(.zero)
                    .clipped()
            }
    }

    /// Removes view from layout completely when condition is true
    @ViewBuilder
    func removeFromLayout(
        if condition: Bool,
        transition: AnyTransition = .opacity,
        animation: Animation = .easeInOut(duration: 0.3)
    ) -> some View {
        if condition {
            EmptyView()
                .transition(transition)
                .animation(animation, value: condition)
        } else {
            self
                .transition(transition)
                .animation(animation, value: condition)
        }
    }

    /// Removes view with edge-specific transition
    @ViewBuilder
    func removeFromEdge(
        if condition: Bool,
        edge: Edge,
        animation: Animation = .easeInOut(duration: 0.3)
    ) -> some View {
        self
            .transition(.asymmetric(
                insertion: .identity,
                removal: .move(edge: edge).combined(with: .opacity)
            ))
            .animation(animation, value: condition)
            .applyIf(condition) { view in
                view.hidden()
                    .frame(width: edge.horizontal ? 0 : nil,
                           height: edge.vertical ? 0 : nil)
                    .padding(.zero)
                    .clipped()
            }
    }
}

// MARK: - Edge Helper
extension Edge {
    var horizontal: Bool {
        self == .leading || self == .trailing
    }

    var vertical: Bool {
        self == .top || self == .bottom
    }
}

// MARK: - Usage Examples

struct SampleTransitionVoiexw: View {
    @State private var showView = true
    @State private var selectedEdge: Edge = .bottom
    @State private var transitionDuration = 0.3

    var body: some View {
        VStack(spacing: 30) {
            // Example 1: Simple removal with transition
            Text("Hello, World!")
                .padding()
                .background(Color.blue.opacity(0.3))
                .cornerRadius(10)
                .removeView(if: !showView, transition: .scaleAndFade)

            // Example 2: Remove from specific edge
            Text("Slide from edge")
                .padding()
                .background(Color.green.opacity(0.3))
                .cornerRadius(10)
                .removeFromEdge(if: !showView, edge: selectedEdge)

            // Example 3: With custom insertion/removal
            Text("Custom transitions")
                .padding()
                .background(Color.orange.opacity(0.3))
                .cornerRadius(10)
                .removeView(
                    if: !showView,
                    insertion: .slideFromTop,
                    removal: .slideFromBottom,
                    animation: .spring(response: 0.5, dampingFraction: 0.7)
                )

            // Example 4: Complete layout removal
            Text("Complete removal")
                .padding()
                .background(Color.purple.opacity(0.3))
                .cornerRadius(10)
                .removeFromLayout(
                    if: !showView,
                    transition: .slideFromTrailing,
                    animation: .easeInOut(duration: transitionDuration)
                )

            // Controls
            VStack(spacing: 15) {
                Toggle("Show Views", isOn: $showView)
                    .toggleStyle(.switch)

                Picker("Removal Edge", selection: $selectedEdge) {
                    Text("Top").tag(Edge.top)
                    Text("Bottom").tag(Edge.bottom)
                    Text("Leading").tag(Edge.leading)
                    Text("Trailing").tag(Edge.trailing)
                }
                .pickerStyle(.segmented)

                HStack {
                    Text("Duration: \(transitionDuration, specifier: "%.1f")s")
                    Slider(value: $transitionDuration, in: 0.1...1.0, step: 0.1)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    SampleTransitionVoiexw()
}


// MARK: - Transition Presets for Common Use Cases
struct ViewTransitions {
    /// Common transition for removing editor panels
    static let editorRemoval: AnyTransition = .asymmetric(
        insertion: .move(edge: .bottom).combined(with: .opacity),
        removal: .move(edge: .bottom).combined(with: .opacity)
    )

    /// Common transition for removing toolbars
    static let toolbarRemoval: AnyTransition = .asymmetric(
        insertion: .move(edge: .top).combined(with: .opacity),
        removal: .move(edge: .top).combined(with: .opacity)
    )

    /// Common transition for side panels
    static let sidePanelRemoval: AnyTransition = .asymmetric(
        insertion: .move(edge: .leading).combined(with: .opacity),
        removal: .move(edge: .leading).combined(with: .opacity)
    )

    /// Fade-only transition
    static let fadeRemoval: AnyTransition = .asymmetric(
        insertion: .opacity,
        removal: .opacity
    )
}

// MARK: - Size Measurement Extension
/// Extension for measuring view sizes efficiently
extension View {
    /// Measures the size of a view and provides it via callback
    /// Uses background GeometryReader to avoid affecting layout
    /// - Parameter size: Callback that receives the measured size
    /// - Returns: A view that measures its size
    @ViewBuilder
    func getSize(_ size: @escaping (CGSize) -> Void) -> some View {
        self.background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
                    .onPreferenceChange(SizePreferenceKey.self) { size($0) }
            }
        )
    }

    @ViewBuilder
    func getFrame(_ frame: @escaping (CGRect) -> Void) -> some View {
        self.background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: FramePreferenceKey.self,
                               value: geometry.frame(in: .global))
                    .onPreferenceChange(FramePreferenceKey.self) { frame($0) }
            }
        )
    }
}

// Separate preference keys for size and frame
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
