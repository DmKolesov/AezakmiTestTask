//
//  ImagePickerView.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import SwiftUI
import PhotosUI

struct ImagePickerView: UIViewControllerRepresentable {
    let sourceType: ImageSource
    let onImagePicked: (UIImage) -> Void
    let onError: (CameraError) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        switch sourceType {
        case .library:
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.filter = .images
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = context.coordinator
            return picker
        case .camera:
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = context.coordinator
            return picker
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(onImagePicked: onImagePicked, onError: onError) }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate {
        let onImagePicked: (UIImage) -> Void
        let onError: (CameraError) -> Void

        init(onImagePicked: @escaping (UIImage) -> Void, onError: @escaping (CameraError) -> Void) {
            self.onImagePicked = onImagePicked
            self.onError = onError
        }

        // UIImagePickerControllerDelegate
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                onImagePicked(uiImage)
            } else {
                onError(.imageProcessingFailed)
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }

        // PHPickerViewControllerDelegate
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let item = results.first,
                  item.itemProvider.canLoadObject(ofClass: UIImage.self) else { return }

            item.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.onError(.photoLibraryError(error))
                    } else if let image = object as? UIImage {
                        self.onImagePicked(image)
                    }
                }
            }
        }
    }
}
