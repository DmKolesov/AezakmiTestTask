//
//  CoreImageProcessor.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

final class CoreImageProcessor {
    func applyFilter(_ filter: PhotoFilter, to image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        let ciFilter = filter.createCIFilter()
        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputImage = ciFilter.outputImage else { return nil }
        
        let context = CIContext(options: [.useSoftwareRenderer: false])
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}
