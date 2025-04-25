//
//  TextElementView.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import SwiftUI

struct TextElementView: View {
    @Binding var element: TextElement
    var imageSize: CGSize
    var onTap: () -> Void
    
    @State private var currentPosition: CGPoint = .zero
    
    // Добавим проверку валидности размеров изображения
    private var isValidSize: Bool {
        imageSize.width > 0 && imageSize.height > 0 && !imageSize.width.isNaN && !imageSize.height.isNaN
    }
    
    var body: some View {
        Text(element.text)
            .font(.custom(element.fontName, size: element.fontSize))
            .foregroundColor(element.color)
            .padding(5)
            .background(Color.black.opacity(0.3))
            .cornerRadius(4)
            .position(currentPosition)
            .gesture(dragGesture)
            .onTapGesture { onTap() }
            .onAppear { updatePosition() }
            .onChange(of: imageSize) { _ in updatePosition() }
            .onChange(of: element.normalizedPosition) { _ in updatePosition() }
    }
    
    private func updatePosition() {
        guard isValidSize else { return }
        
        let x = element.normalizedPosition.x.clamped(to: 0...1) * imageSize.width
        let y = element.normalizedPosition.y.clamped(to: 0...1) * imageSize.height
        
        currentPosition = CGPoint(
            x: x.isNaN ? 0 : x,
            y: y.isNaN ? 0 : y
        )
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                guard isValidSize else { return }
                
                let newX = value.location.x.clamped(to: 0...imageSize.width)
                let newY = value.location.y.clamped(to: 0...imageSize.height)
                
                let normalizedX = (newX / imageSize.width).clamped(to: 0...1)
                let normalizedY = (newY / imageSize.height).clamped(to: 0...1)
                
                element.normalizedPosition = CGPoint(
                    x: normalizedX,
                    y: normalizedY
                )
            }
    }
}
