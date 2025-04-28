//
//  ExportViewModel.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import SwiftUI

final class ExportViewModel: ObservableObject {
    private let photoRepository: PhotoRepositoryProtocol
    
    init(photoRepository: PhotoRepositoryProtocol = PhotoRepository()) {
        self.photoRepository = photoRepository
    }
    
    func saveImage(_ image: UIImage) async throws {
        try await photoRepository.saveImage(image)
    }
}
