//
//  ImageProcessingService.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import SwiftUI
import PencilKit

protocol ImageProcessingServiceProtocol {
    func processImage(_ image: UIImage) async throws -> UIImage
    func applyFilter(_ filter: PhotoFilter, to image: UIImage) async throws -> UIImage
    func renderFinalImage(baseImage: UIImage?, drawing: PKDrawing, texts: [TextElement]) -> UIImage?
}

actor ImageProcessingService: ImageProcessingServiceProtocol {
    private let context = CIContext()
    
    func processImage(_ image: UIImage) async throws -> UIImage {
        return image
    }
    
    func applyFilter(_ filter: PhotoFilter, to image: UIImage) async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    guard let ciImage = CIImage(image: image) else {
                        throw ImageError.filterApplicationFailed
                    }
                    
                    let ciFilter = filter.createCIFilter()
                    ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
                    
                    guard let outputImage = ciFilter.outputImage else {
                        throw ImageError.filterApplicationFailed
                    }
                    
                    guard let cgImage = self.context.createCGImage(
                        outputImage,
                        from: outputImage.extent
                    ) else {
                        throw ImageError.filterRenderFailed
                    }
                    
                    let result = UIImage(
                        cgImage: cgImage,
                        scale: image.scale,
                        orientation: .up
                    )
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    nonisolated func renderFinalImage(
        baseImage: UIImage?,
        drawing: PKDrawing,
        texts: [TextElement]
    ) -> UIImage? {
        guard let baseImage else { return nil }
        
        let renderer = UIGraphicsImageRenderer(size: baseImage.size)
        
        return renderer.image { ctx in
            // Base image
            baseImage.draw(in: CGRect(origin: .zero, size: baseImage.size))
            
            // Draw PencilKit drawing
            let drawingImage = drawing.image(
                from: CGRect(origin: .zero, size: baseImage.size),
                scale: baseImage.scale
            )
            drawingImage.draw(in: CGRect(origin: .zero, size: baseImage.size))
            
            // Draw text elements
            for text in texts {
                let fontSize = text.fontSize * baseImage.scale
                let font = UIFont(name: text.fontName, size: fontSize)
                    ?? UIFont.systemFont(ofSize: fontSize)
                
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: UIColor(text.color)
                ]
                
                let position = CGPoint(
                    x: text.normalizedPosition.x * baseImage.size.width,
                    y: text.normalizedPosition.y * baseImage.size.height
                )
                
                NSString(string: text.text).draw(
                    at: position,
                    withAttributes: attributes
                )
            }
        }
    }
}
