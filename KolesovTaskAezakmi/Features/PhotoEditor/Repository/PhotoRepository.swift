//
//  PhotoRepository.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import SwiftUI
import Photos

protocol PhotoRepositoryProtocol {
    func saveImage(_ image: UIImage) async throws
}

final class PhotoRepository: PhotoRepositoryProtocol {
    func saveImage(_ image: UIImage) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            } completionHandler: { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if success {
                    continuation.resume(returning: ())
                } else {
                    continuation.resume(throwing: ImageError.saveFailed)
                }
            }
        }
    }
}

