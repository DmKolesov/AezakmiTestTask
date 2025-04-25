//
//  TextElementsViewModel.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import SwiftUI

final class TextElementsViewModel: ObservableObject {
    @Published var textElements: [TextElement] = []
    @Published var selectedTextElement: TextElement?
    @Published var newText: String = ""
    
    func addText(_ text: String, fontSize: CGFloat, color: Color, fontName: String, position: CGPoint = .zero) {
        let element = TextElement(
            text: text,
            normalizedPosition: position,
            fontSize: fontSize,
            color: color,
            fontName: fontName
        )
        textElements.append(element)
    }
    
    func updateElement(id: UUID, text: String, fontSize: CGFloat, color: Color, fontName: String) {
        if let index = textElements.firstIndex(where: { $0.id == id }) {
            textElements[index].update(
                text: text,
                fontSize: fontSize,
                color: color,
                fontName: fontName
            )
        }
    }
    
    func deleteElement(id: UUID) {
        textElements.removeAll { $0.id == id }
    }
}

