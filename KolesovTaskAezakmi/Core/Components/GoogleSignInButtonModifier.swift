//
//  GoogleSignInButtonModifier.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import SwiftUI

struct GoogleSignInButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack(spacing: 10) {
            Image("google-logo")
                .resizable()
                .frame(width: 20, height: 20)
            content
        }
        .font(.headline)
        .foregroundColor(.primary)
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .contentShape(Rectangle())
        .accessibilityLabel("Sign in with Google")
    }
}
