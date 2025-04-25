//
//  MainViewModel.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import SwiftUI
import Combine
import PencilKit

// MARK: - MainViewModel
@MainActor
final class MainViewModel: ObservableObject {
    // Sub-view models
    var toolbarVM: ToolbarViewModel
    var imageVM: ImageProcessingViewModel
    var canvasVM: CanvasViewModel
    var textVM: TextElementsViewModel
    var exportVM: ExportViewModel

    // Combine cancellables
    private var cancellables = Set<AnyCancellable>()

    // Shared UI state
    @Published var displayImage: UIImage? = nil
    @Published var errorMessage: String?
    @Published var scale: CGFloat = 1.0
    @Published var rotation: Angle = .zero

    init() {
        self.toolbarVM = ToolbarViewModel()
        self.imageVM = ImageProcessingViewModel()
        self.canvasVM = CanvasViewModel()
        self.textVM = TextElementsViewModel()
        self.exportVM = ExportViewModel()

        setupPublishers()
    }

    private func setupPublishers() {
        // Forward image updates
        imageVM.$displayImage
            .receive(on: DispatchQueue.main)
            .assign(to: \.displayImage, on: self)
            .store(in: &cancellables)
        
        // Forward toolbar changes
        toolbarVM.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
        
        // Forward canvas changes
        canvasVM.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
        
        // Forward text elements changes
        textVM.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
    }
    
    

//    func renderFinalImage() -> UIImage? {
//        imageVM.render(
//            drawing: canvasVM.currentDrawing,
//            texts: textVM.textElements
//        )
//    }
    
    func renderFinalImage() -> UIImage? {
            guard let baseImage = imageVM.originalImage,
                  baseImage.size.width > 0,
                  baseImage.size.height > 0,
                  !baseImage.size.width.isNaN,
                  !baseImage.size.height.isNaN else {
                print("Invalid base image size")
                return nil
            }
            
            // Проверка параметров текста перед рендерингом
            let validTexts = textVM.textElements.map { element -> TextElement in
                var element = element
                element.normalizedPosition = CGPoint(
                    x: element.normalizedPosition.x.clamped(to: 0...1),
                    y: element.normalizedPosition.y.clamped(to: 0...1)
                )
                element.fontSize = element.fontSize.clamped(to: 8...120)
                return element
            }
            
            return imageVM.render(
                drawing: canvasVM.currentDrawing,
                texts: validTexts
            )
        }

    func handleError(_ error: Error) {
        if let imageError = error as? ImageError {
            errorMessage = imageError.errorDescription
        } else {
            errorMessage = error.localizedDescription
        }
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            errorMessage = nil
        }
    }
}


