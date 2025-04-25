//
//  ToolbarButtonModifier.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import SwiftUI

struct ToolbarButtonModifier: ViewModifier {
    var isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(isActive ? .white : .primary)
            .frame(width: 44, height: 44)
            .background(isActive ? Color.blue : Color.secondary.opacity(0.15))
            .cornerRadius(8)
            .shadow(color: isActive ? .blue.opacity(0.2) : .clear, radius: 3, y: 2)
    }
}
