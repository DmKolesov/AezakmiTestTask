//
//  CanvasViewModel.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import PencilKit

final class CanvasViewModel: ObservableObject {
    @Published var currentDrawing = PKDrawing()
    @Published var drawingTool = PKInkingTool(.pen, color: .black, width: 5)
    @Published var currentTool: ToolMode = .none
    
    func resetDrawing() {
        currentDrawing = PKDrawing()
    }
}
