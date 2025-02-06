//
//  File.swift
//  EazySwiftUI
//
//  Created by Elioene Silves Fernandes on 06/02/2025.
//

import SwiftUI

/// A struct representing a swipe action with customizable appearance and behavior.
struct SwipeAction: Identifiable {
    
    /// A unique identifier for the swipe action.
    var id = UUID().uuidString
    
    /// The system image name to be used as an icon for the action.
    var symbolImage: String
    
    /// The color of the icon.
    var tint: Color
    
    /// The background color of the action button.
    var background: Color
    
    // MARK: - Appearance Properties
    
    /// The font used for the action label.
    var font: Font = .title3
    
    /// The size of the action button.
    var size: CGSize = .init(width: 45, height: 45)
    
    /// The shape of the action button.
    var shape: some Shape = .circle
    
    // MARK: - Action Handler
    
    /// A closure that executes when the action is triggered.
    /// - Parameter isCompleted: A boolean flag that can be modified within the closure.
    var action: (inout Bool) -> Void
}
