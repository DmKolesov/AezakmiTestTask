//
//  ImageProcessingViewModel.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import SwiftUI
import Combine
import PencilKit

@MainActor
final class ImageProcessingViewModel: ObservableObject {
    @Published var originalImage: UIImage?
    @Published var filteredImage: UIImage?
    @Published var selectedFilter: PhotoFilter?
    @Published var displayImage: UIImage?

    private let processor: ImageProcessingServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(processor: ImageProcessingServiceProtocol = ImageProcessingService()) {
        self.processor = processor
        setupPublishers()
    }

    private func setupPublishers() {
        Publishers.CombineLatest($filteredImage, $originalImage)
            .map { filtered, original in filtered ?? original }
            .receive(on: DispatchQueue.main)
            .assign(to: \.displayImage, on: self)
            .store(in: &cancellables)
    }

    func load(image: UIImage) {
        originalImage = image
        filteredImage = image
        selectedFilter = nil

        Task {
            do {
                let processed = try await processor.processImage(image)
                await MainActor.run {
                    self.originalImage = processed
                    self.filteredImage = processed
                }
            } catch {
                print("Error processing image: \(error.localizedDescription)")
            }
        }
    }

    func apply(filter: PhotoFilter) {
        guard let base = originalImage else { return }
        Task {
            do {
                let result = try await processor.applyFilter(filter, to: base)
                await MainActor.run {
                    self.filteredImage = result
                    self.selectedFilter = filter
                }
            } catch {
                print("Error applying filter: \(error.localizedDescription)")
            }
        }
    }

    func render(drawing: PKDrawing, texts: [TextElement]) -> UIImage? {
        processor.renderFinalImage(
            baseImage: displayImage,
            drawing: drawing,
            texts: texts
        )
    }

    func resetFilter() {
        filteredImage = originalImage
        selectedFilter = nil
    }
}

