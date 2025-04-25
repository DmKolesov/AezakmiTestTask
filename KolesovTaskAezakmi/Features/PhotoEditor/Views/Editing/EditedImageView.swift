//
//  EditedImageView.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import SwiftUI

struct EditedImageView: View {
    
    let image: UIImage?
    @Binding var scale: CGFloat
    @Binding var rotation: Angle
    
    @State private var currentScale: CGFloat = 1.0
    @State private var previousScale: CGFloat = 1.0
    @State private var currentRotation: Angle = .zero
    @State private var previousRotation: Angle = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let uiImage = image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                    
                        .scaleEffect(currentScale * scale)
                        .rotationEffect(currentRotation + rotation)
                        .gesture(
                            SimultaneousGesture(magnificationGesture, rotationGesture)
                        )
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .drawingGroup()
                } else {
                    Color.gray
                        .overlay(
                            Text("Выберите изображение")
                                .foregroundColor(.white)
                        )
                }
            }
        }
    }
    
    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let newScale = value * previousScale
                currentScale = max(min(newScale, 5.0), 0.1)
            }
            .onEnded { _ in
                previousScale = currentScale
                scale = currentScale
            }
    }
    
    private var rotationGesture: some Gesture {
        RotationGesture()
            .onChanged { angle in
                currentRotation = angle + previousRotation
            }
            .onEnded { _ in
                previousRotation = currentRotation
                rotation = currentRotation
            }
    }
}
