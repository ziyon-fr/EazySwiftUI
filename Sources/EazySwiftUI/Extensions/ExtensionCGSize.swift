//
//  ExtensionCGSize.swift
//  EazySwiftUI
//
//  Created by Leon Salvatore on 30.04.2025.
//

import SwiftUI

public extension CGSize {
    /// A set of predefined common `CGSize` values for various use cases.

    // MARK: - Generic Sizes

    /// Represents a zero-size CGSize (`width: 0, height: 0`).
    static var zero: Self { .init(width: 0, height: 0) }

    // MARK: - Image Sizes

    /// Represents a standard Full HD image size (`width: 1920, height: 1080`).
    static var image1920x1080: Self { .init(width: 1920, height: 1080) }

    /// Represents a square 1080p image size (`width: 1080, height: 1080`).
    static var image1080: Self { .init(width: 1080, height: 1080) }

    /// Represents a 720p image size (`width: 1280, height: 720`).
    static var image1280x720: Self { .init(width: 1280, height: 720) }

    /// Represents a small square image (`width: 240, height: 240`).
    static var image240: Self { .init(width: 240, height: 240) }

    /// Represents a medium square image (`width: 320, height: 320`).
    static var image320: Self { .init(width: 320, height: 320) }

    /// Represents a large square image (`width: 512, height: 512`).
    static var image512: Self { .init(width: 512, height: 512) }

    /// Represents a thumbnail-sized image (`width: 150, height: 150`).
    static var thumbnail: Self { .init(width: 150, height: 150) }

    // MARK: - Social Media Sizes

    /// Instagram post size (`width: 1080, height: 1080` - Square).
    static var instagramPost: Self { .init(width: 1080, height: 1080) }

    /// Instagram story size (`width: 1080, height: 1920` - Vertical).
    static var instagramStory: Self { .init(width: 1080, height: 1920) }

    /// Facebook post size (`width: 1200, height: 630` - Landscape).
    static var facebookPost: Self { .init(width: 1200, height: 630) }

    /// Facebook cover photo (`width: 820, height: 312`).
    static var facebookCover: Self { .init(width: 820, height: 312) }

    /// Twitter post size (`width: 1600, height: 900`).
    static var twitterPost: Self { .init(width: 1600, height: 900) }

    /// Twitter header size (`width: 1500, height: 500`).
    static var twitterHeader: Self { .init(width: 1500, height: 500) }

    /// TikTok video size (`width: 1080, height: 1920` - Full-screen vertical).
    static var tiktokVideo: Self { .init(width: 1080, height: 1920) }

    /// YouTube video thumbnail size (`width: 1280, height: 720` - Standard thumbnail).
    static var youtubeThumbnail: Self { .init(width: 1280, height: 720) }

    /// YouTube channel cover size (`width: 2560, height: 1440` - Recommended for high-res displays).
    static var youtubeCover: Self { .init(width: 2560, height: 1440) }

    // MARK: - Screen Sizes

    /// iPhone SE screen size (`width: 375, height: 667` - Older models).
    static var iPhoneSE: Self { .init(width: 375, height: 667) }

    /// iPhone Pro Max screen size (`width: 430, height: 932` - iPhone 13 Pro Max, 14 Pro Max, 15 Pro Max, 16 Pro Max).
       static var iPhoneProMax: Self { .init(width: 430, height: 932) }

    /// Standard iPhone screen size (`width: 390, height: 844` - iPhone 12, 13, 14).
    static var iPhoneStandard: Self { .init(width: 390, height: 844) }

    /// iPad screen size (`width: 768, height: 1024` - iPad Mini/Air).
    static var iPad: Self { .init(width: 768, height: 1024) }

    /// iPad Pro screen size (`width: 1024, height: 1366`).
    static var iPadPro: Self { .init(width: 1024, height: 1366) }

    // MARK: - Aspect Ratios

    /// Standard 16:9 aspect ratio (`width: 16, height: 9`).
    static var aspect16by9: Self { .init(width: 16, height: 9) }

    /// Standard 4:3 aspect ratio (`width: 4, height: 3`).
    static var aspect4by3: Self { .init(width: 4, height: 3) }
}
