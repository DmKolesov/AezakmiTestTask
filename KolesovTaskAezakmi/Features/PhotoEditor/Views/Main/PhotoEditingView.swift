//
//  PhotoEditingView.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import SwiftUI
import PhotosUI
import AVFoundation

struct PhotoEditingView: View {
    @StateObject private var mainVM = MainViewModel()
    @State private var selectedSource: ImageSource = .library
    @State private var showImagePicker = false
    @State private var showShareSheet = false
    @State private var shareImages: [UIImage] = []
    @State private var cameraError: CameraError?
    @State private var saveSuccess = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                EditorToolbarView(
                    toolbarVM: mainVM.toolbarVM,
                    selectedSource: $selectedSource,
                    onLoadTap: handleSelectTap
                )
                .zIndex(1)

                GeometryReader { geometry in
                    ZStack {
                        EditedImageView(
                            image: mainVM.imageVM.displayImage,
                            scale: $mainVM.scale,
                            rotation: $mainVM.rotation
                        )

                        if mainVM.toolbarVM.currentTool == .draw {
                            DrawingCanvasView(
                                drawing: $mainVM.canvasVM.currentDrawing,
                                tool: $mainVM.canvasVM.drawingTool
                            )
                            .transition(.opacity)
                        }

                        TextElementsLayer(
                            textElements: $mainVM.textVM.textElements,
                            imageSize: geometry.size,
                            onSelectElement: { element in
                                mainVM.textVM.selectedTextElement = element
                                mainVM.toolbarVM.showTextEditor = true
                            }
                        )
                    }
                }

                VStack(spacing: 0) {
                    if mainVM.toolbarVM.showFilters {
                        FilterPaletteView(vm: mainVM.imageVM)
                            .padding(.bottom, mainVM.toolbarVM.currentTool == .draw ? 60 : 16)
                    }

                    if mainVM.toolbarVM.currentTool == .draw {
                        DrawingToolsView(
                            selectedTool: $mainVM.canvasVM.drawingTool
                        )
                    }
                }
                .animation(.spring(), value: mainVM.toolbarVM.currentTool)
            }
            .navigationTitle("Фоторедактор")
            .toolbar { mainToolbar }
            .alert(item: $cameraError) { error in
                Alert(
                    title: Text("Ошибка"),
                    message: Text(error.localizedDescription),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert("Успех", isPresented: $saveSuccess, actions: {
                Button("OK", role: .cancel) {}
            }, message: {
                Text("Изображение успешно сохранено")
            })
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(
                    sourceType: selectedSource,
                    onImagePicked: { image in
                        mainVM.imageVM.load(image: image)
                    },
                    onError: { error in
                        cameraError = error
                    }
                )
            }
            .sheet(isPresented: $mainVM.toolbarVM.showTextEditor) {
                TextEditorView(textVM: mainVM.textVM)
            }
            .sheet(isPresented: $showShareSheet) {
                ActivityView(images: shareImages)
            }
        }
    }

    private func handleSelectTap() {
        #if targetEnvironment(simulator)
        if selectedSource == .camera {
            cameraError = .simulatorCameraUnavailable
            return
        }
        #endif

        guard selectedSource != .camera || UIImagePickerController.isSourceTypeAvailable(.camera) else {
            cameraError = .deviceUnavailable
            return
        }
        if selectedSource == .camera {
            requestCameraPermission()
        } else {
            showImagePicker = true
        }
    }

    private func requestCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            DispatchQueue.main.async { showImagePicker = true }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    granted ? (showImagePicker = true) : (cameraError = .permissionDenied)
                }
            }
        case .denied, .restricted:
            cameraError = .permissionRequired
        @unknown default:
            cameraError = .unknown
        }
    }

    @ToolbarContentBuilder
    private var mainToolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Menu {
                Button("Сохранить", systemImage: "square.and.arrow.down") {
                    Task { await saveImage() }
                }
                Button("Поделиться", systemImage: "square.and.arrow.up") {
                    prepareShare()
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }

    private func saveImage() async {
        guard let image = mainVM.renderFinalImage() else {
            cameraError = .imageProcessingFailed
            return
        }
        do {
            try await mainVM.exportVM.saveImage(image)
            saveSuccess = true
        } catch {
            cameraError = .saveFailed(error)
        }
    }

    private func prepareShare() {
        // Симулятор не поддерживает шаринг
        #if targetEnvironment(simulator)
        cameraError = .shareUnavailable
        return
        #endif

        guard let image = mainVM.renderFinalImage() else {
            cameraError = .imageProcessingFailed
            return
        }
        shareImages = [image]
        showShareSheet = true
    }
}
