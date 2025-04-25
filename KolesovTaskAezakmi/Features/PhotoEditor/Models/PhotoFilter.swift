//
//  PhotoFilter.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import CoreImage

enum PhotoFilter: Identifiable, CaseIterable {
    case sepia(intensity: Double = 1.0)
    case blackAndWhite
    case vignette(intensity: Double = 0.9, radius: Double = 1.0)
    case sharpen(sharpness: Double = 0.4)
    
    static var allCases: [PhotoFilter] {
         [
             .sepia(),
             .blackAndWhite,
             .vignette(),
             .sharpen()
         ]
     }
    
    var id: String {
        switch self {
        case .sepia: return "sepia"
        case .blackAndWhite: return "bw"
        case .vignette: return "vignette"
        case .sharpen: return "sharpen"
        }
    }
    
    var displayName: String {
        switch self {
        case .sepia: return "Sepia"
        case .blackAndWhite: return "B&W"
        case .vignette: return "Vignette"
        case .sharpen: return "Sharpen"
        }
    }
    
    func createCIFilter() -> CIFilter {
        switch self {
        case .sepia(let intensity):
            let filter = CIFilter(name: "CISepiaTone")!
            filter.setValue(Float(intensity), forKey: kCIInputIntensityKey)
            return filter
            
        case .blackAndWhite:
            let filter = CIFilter(name: "CIColorControls")!
            filter.setValue(0.0, forKey: kCIInputSaturationKey)
            return filter
            
        case .vignette(let intensity, let radius):
            let filter = CIFilter(name: "CIVignette")!
            filter.setValue(Float(intensity), forKey: kCIInputIntensityKey)
            filter.setValue(Float(radius), forKey: kCIInputRadiusKey)
            return filter
            
        case .sharpen(let sharpness):
            let filter = CIFilter(name: "CISharpenLuminance")!
            filter.setValue(Float(sharpness), forKey: kCIInputSharpnessKey)
            return filter
        }
    }
}

extension PhotoFilter: Equatable {
    static func == (lhs: PhotoFilter, rhs: PhotoFilter) -> Bool {
        switch (lhs, rhs) {
        case (.sepia(let a), .sepia(let b)):
            return a == b
        case (.blackAndWhite, .blackAndWhite):
            return true
        case (.vignette(let aIntensity, let aRadius), .vignette(let bIntensity, let bRadius)):
            return aIntensity == bIntensity && aRadius == bRadius
        case (.sharpen(let aSharpness), .sharpen(let bSharpness)):
            return aSharpness == bSharpness
        default:
            return false
        }
    }
}

