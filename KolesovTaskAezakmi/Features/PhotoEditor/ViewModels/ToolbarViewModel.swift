//
//  ToolbarViewModel.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
final class ToolbarViewModel: ObservableObject {
    @Published var currentTool: ToolMode = .none
    @Published var showFilters: Bool = false
    @Published var showTextEditor: Bool = false

    func toggleTool(_ tool: ToolMode) {
        currentTool = (currentTool == tool) ? .none : tool
    }
}
