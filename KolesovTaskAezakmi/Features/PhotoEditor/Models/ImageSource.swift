//
//  ImageSource.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import SwiftUI

enum ImageSource {
    case library
    case camera
    
    var sourceType: UIImagePickerController.SourceType {
        switch self {
        case .library: return .photoLibrary
        case .camera: return .camera
        }
    }
}
