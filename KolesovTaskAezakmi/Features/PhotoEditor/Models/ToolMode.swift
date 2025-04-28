//
//  ToolMode.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation

enum ToolMode {
    case none, draw, text, filter
    var isDrawing: Bool { self == .draw }
}
