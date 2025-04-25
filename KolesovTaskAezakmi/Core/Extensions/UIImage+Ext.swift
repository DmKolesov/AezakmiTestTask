//
//  UIImage+Ext.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import SwiftUI

extension UIImage {
    func fixedOrientation() -> UIImage {
        if imageOrientation == .up { return self }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage ?? self
    }
}
