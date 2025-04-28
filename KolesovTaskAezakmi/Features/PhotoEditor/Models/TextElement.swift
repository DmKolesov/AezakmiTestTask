//
//  TextElement.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import SwiftUI

//struct TextElement: Identifiable, Equatable {
//    let id = UUID()
//    var text: String
//    var normalizedPosition: CGPoint
//    var fontSize: CGFloat
//    var color: Color
//    var fontName: String
//    
//    init(text: String, normalizedPosition: CGPoint, fontSize: CGFloat, color: Color, fontName: String) {
//        self.text = text
//        self.normalizedPosition = CGPoint(
//            x: normalizedPosition.x.clamped(to: 0...1),
//            y: normalizedPosition.y.clamped(to: 0...1)
//        )
//        self.fontSize = fontSize.clamped(to: 8...120)
//        self.color = color
//        self.fontName = fontName
//    }
//    
//    mutating func update(text: String, fontSize: CGFloat, color: Color, fontName: String) {
//        self.text = text
//        self.fontSize = fontSize.clamped(to: 8...120)
//        self.color = color
//        self.fontName = fontName
//    }
//}


struct TextElement: Identifiable, Equatable {
    let id = UUID()
    var text: String
    var normalizedPosition: CGPoint
    var fontSize: CGFloat
    var color: Color
    var fontName: String
    
    init(text: String, normalizedPosition: CGPoint, fontSize: CGFloat, color: Color, fontName: String) {
        self.text = text
        self.normalizedPosition = Self.clampedPosition(normalizedPosition)
        self.fontSize = Self.clampedFontSize(fontSize)
        self.color = color
        self.fontName = fontName.isEmpty ? "Helvetica Neue" : fontName
    }
    
    private static func clampedPosition(_ position: CGPoint) -> CGPoint {
        CGPoint(
            x: position.x.clamped(to: 0...1),
            y: position.y.clamped(to: 0...1)
        )
    }
    
    private static func clampedFontSize(_ size: CGFloat) -> CGFloat {
        size.clamped(to: 8...120)
    }
    
    mutating func update(text: String, fontSize: CGFloat, color: Color, fontName: String) {
        self.text = text
        self.fontSize = Self.clampedFontSize(fontSize)
        self.color = color
        self.fontName = fontName.isEmpty ? "Helvetica Neue" : fontName
    }
}
