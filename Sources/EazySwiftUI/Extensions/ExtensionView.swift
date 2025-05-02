//
//  ExtensionView.swift
//  EazySwiftUI
//
//  Created by Leon Salvatore on 02.05.2025.
//

import SwiftUI

/// A SwiftUI extension that adds custom corner radius functionality to any View.
public extension View {
    
    /// Applies corner radius to specific corners of a view.
    /// - Parameters:
    ///   - radius: The radius of the rounded corners.
    ///   - corners: The corners to apply the radius to (e.g., topLeft, bottomRight, etc.).
    /// - Returns: A view with the specified corners rounded.
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(.rect(cornerRadius: radius, corners: corners))
    }
}

