//
//  EditorToolBarView.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import SwiftUI

struct EditorToolbarView: View {
    @ObservedObject var toolbarVM: ToolbarViewModel
    @Binding var selectedSource: ImageSource
    var onLoadTap: () -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                Picker("Source", selection: $selectedSource) {
                    Text("Library").tag(ImageSource.library)
                    Text("Camera").tag(ImageSource.camera)
                }
                .pickerStyle(.segmented)
                .frame(width: 180)

                Button(action: onLoadTap) {
                    Label("Load", systemImage: "photo")
                        .modifier(SecondaryButtonModifier())
                }

                Button {
                    toolbarVM.toggleTool(.draw)
                } label: {
                    Image(systemName: "pencil.tip")
                        .symbolVariant(toolbarVM.currentTool == .draw ? .fill : .none)
                        .modifier(ToolbarButtonModifier(isActive: toolbarVM.currentTool == .draw))
                }

                Button {
                    withAnimation(.spring()) {
                        toolbarVM.showFilters.toggle()
                    }
                } label: {
                    Image(systemName: "camera.filters")
                        .modifier(ToolbarButtonModifier(isActive: toolbarVM.showFilters))
                }

                Button {
                    toolbarVM.showTextEditor = true
                } label: {
                    Image(systemName: "textformat")
                        .modifier(ToolbarButtonModifier(isActive: false))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(.bar)
    }
}

