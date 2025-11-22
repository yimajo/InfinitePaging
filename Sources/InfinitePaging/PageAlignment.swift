/*
 PageAlignment.swift
 InfinitePaging

 Created by Takuto Nakamura on 2023/11/07.
*/

import SwiftUI

public enum PageAlignment: String, CaseIterable {
    case horizontal
    case vertical

    func scalar(_ size: CGSize) -> CGFloat {
        switch self {
        case .horizontal:
            size.width
        case .vertical:
            size.height
        }
    }

    func offset(_ value: CGFloat) -> CGSize {
        switch self {
        case .horizontal: 
            CGSize(width: value, height: 0)
        case .vertical:
            CGSize(width: 0, height: value)
        }
    }

    // Returns the movement amount in the direction perpendicular to the main axis
    func crossScalar(_ translation: CGSize) -> CGFloat {
        switch self {
        case .horizontal:
            return translation.height
        case .vertical:
            return translation.width
        }
    }
}
