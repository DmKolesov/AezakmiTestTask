//
//  ImageError.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation

enum ImageError: LocalizedError {
    case noImageToSave
    case filterApplicationFailed
    case imageProcessingFailed
    case filterRenderFailed
    case saveFailed
    
    var errorDescription: String? {
        switch self {
        case .noImageToSave: return "No image available for saving"
        case .filterApplicationFailed: return "Failed to apply filter"
        case .imageProcessingFailed: return "Image processing failed"
        case .saveFailed: return "Failed to save image"
        case .filterRenderFailed: return "Cannot filter render"
            
        }
    }
}
