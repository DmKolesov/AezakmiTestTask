//
//  PrimaryButtonModifier.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation
import SwiftUI

struct PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.accentColor)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            )
            .contentShape(Rectangle())
            .accessibilityLabel("Primary Action")
    }
}

extension View {
    func primaryButton() -> some View {
        modifier(PrimaryButtonModifier())
    }
    
    func googleSignInButton() -> some View {
        modifier(GoogleSignInButtonModifier())
    }
}

