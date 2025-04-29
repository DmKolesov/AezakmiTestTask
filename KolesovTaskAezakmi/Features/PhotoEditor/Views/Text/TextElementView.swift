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
    @State private var contentSize: CGSize = .zero

    private var isValidSize: Bool {
        imageSize.width > 0 && imageSize.height > 0 && !imageSize.width.isNaN && !imageSize.height.isNaN
    }
    
    var body: some View {
        Text(element.text)
            .font(.custom(element.fontName, size: element.fontSize))
            .foregroundColor(element.color)
            .padding(5)
            .background(GeometryReader { geo in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geo.size)
            })
            .background(Color.black.opacity(0.3))
            .cornerRadius(4)
            .position(currentPosition)
            .onPreferenceChange(SizePreferenceKey.self) { contentSize = $0 }
            .gesture(dragGesture)
            .onTapGesture { onTap() }
            .onAppear { updatePosition(animated: true) }
            .onChange(of: imageSize) { _ in updatePosition(animated: false) }
            .onChange(of: element.normalizedPosition) { _ in updatePosition(animated: true) }
    }
    
    private func updatePosition(animated: Bool) {
        guard isValidSize else { return }
        guard imageSize.width > 0, imageSize.height > 0 else {
            currentPosition = .zero
            return
        }
        
        let clampedX = element.normalizedPosition.x.clamped(to: 0...1)
        let clampedY = element.normalizedPosition.y.clamped(to: 0...1)
        
        let newX = clampedX * imageSize.width
        let newY = clampedY * imageSize.height
        
        let adjustedPosition = CGPoint(
            x: newX.isNaN ? 0 : newX,
            y: newY.isNaN ? 0 : newY
        )
        let safeX = newX.isFinite ? newX : 0
        let safeY = newY.isFinite ? newY : 0
        
        withAnimation(animated ? .easeInOut(duration: 0.15) : nil) {
            currentPosition = adjustedPosition
        }
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 1)
            .onChanged { value in
                guard isValidSize else { return }
                
                let halfWidth = contentSize.width / 2
                let halfHeight = contentSize.height / 2
                
                let adjustedLocation = CGPoint(
                    x: max(halfWidth, min(value.location.x, imageSize.width - halfWidth)),
                    y: max(halfHeight, min(value.location.y, imageSize.height - halfHeight))
                )
                
                let normalizedX = (adjustedLocation.x / imageSize.width).clamped(to: 0...1)
                let normalizedY = (adjustedLocation.y / imageSize.height).clamped(to: 0...1)
                
                element.normalizedPosition = CGPoint(
                    x: normalizedX,
                    y: normalizedY
                )
            }
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
