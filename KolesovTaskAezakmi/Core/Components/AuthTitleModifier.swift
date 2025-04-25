//
//  AuthTitleModifier.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation
import SwiftUI

struct AuthTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundColor(.secondary)
            .accessibilityHidden(true)
    }
}

struct AuthFieldModifier: ViewModifier {
    var hasError: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.body)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(hasError ? Color.red : Color(.systemGray4), lineWidth: 1)
            )
            .contentShape(Rectangle())
            .accessibilityElement(children: .combine)
    }
}

extension View {
    func authTitleStyle() -> some View {
        self.modifier(AuthTitleModifier())
    }

    func authFieldStyle(hasError: Bool = false) -> some View {
        self.modifier(AuthFieldModifier(hasError: hasError))
    }
}

