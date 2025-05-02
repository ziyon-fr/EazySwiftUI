//
//  ExtensionShape.swift
//  EazySwiftUI
//
//  Created by Leon Salvatore on 02.05.2025.
//

import SwiftUI

/// An extension on `Shape` that provides a convenience method for creating `CustomCornerShape`.
public extension Shape where Self == CustomCornerShape {
    
    /// Creates a rectangle shape with custom rounded corners.
    /// - Parameters:
    ///   - cornerRadius: The radius to use for the rounded corners.
    ///   - corners: The set of corners to round (e.g., [.topLeft, .bottomRight]).
    /// - Returns: A `CustomCornerShape` configured with the specified corner radius and corners.
    static func rect(cornerRadius: CGFloat, corners: UIRectCorner) -> CustomCornerShape {
        return .init(radius: cornerRadius, corners: corners)
    }
}

/// A custom shape that allows rounding specific corners with individual radii.
public struct CustomCornerShape: Shape {
    
    /// The radius to use when drawing rounded corners.
    var radius: CGFloat = .infinity
    
    /// The corners of the rectangle to round.
    var corners: UIRectCorner = .allCorners
    
    /// Creates a path for the shape within the given rectangle.
    /// - Parameter rect: The rectangle in which to draw the shape.
    /// - Returns: A path that describes the shape with specified rounded corners.
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        
        return .init(path.cgPath)
    }
}
