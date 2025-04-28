//
//  TextElementsLayer.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import SwiftUI

struct TextElementsLayer: View {
    @Binding var textElements: [TextElement]
    var imageSize: CGSize
    var onSelectElement: (TextElement) -> Void

    private var isValidSize: Bool {
        imageSize.width > 0 && imageSize.height > 0 && !imageSize.width.isNaN && !imageSize.height.isNaN
    }
    
    var body: some View {
        ZStack {
            if isValidSize {
                ForEach($textElements) { $element in
                    TextElementView(
                        element: $element,
                        imageSize: imageSize,
                        onTap: { onSelectElement(element) }
                    )
                }
            }
        }
        .clipped()
    }
}
