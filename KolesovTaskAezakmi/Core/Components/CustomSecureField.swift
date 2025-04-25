//
//  CustomSecureField.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation
import SwiftUI

public struct CustomSecureField: View {
    private let placeholder: String
    @Binding private var text: String
    private let title: String
    private let hasError: Bool
    private let onCommit: (() -> Void)?
    
    @State private var isSecure: Bool = true
    
    public init(
        placeholder: String,
        text: Binding<String>,
        title: String,
        hasError: Bool = false,
        onCommit: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.title = title
        self.hasError = hasError
        self.onCommit = onCommit
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .authTitleStyle()
                .accessibilityIdentifier("authLabel_\(title)")
            
            HStack {
                ZStack {
                    secureTextField
                    plainTextField
                }
                
                visibilityToggleButton
            }
            .authFieldStyle(hasError: hasError)
        }
    }
    
    @ViewBuilder
    private var secureTextField: some View {
        if isSecure {
            SecureField(placeholder, text: $text, onCommit: {
                onCommit?()
            })
        }
    }
    
    @ViewBuilder
    private var plainTextField: some View {
        if !isSecure {
            TextField(placeholder, text: $text, onCommit: {
                onCommit?()
            })
        }
    }
    
    private var visibilityToggleButton: some View {
        Button(action: toggleVisibility) {
            Image(systemName: isSecure ? "eye.slash" : "eye")
                .foregroundColor(.secondary)
                .accessibilityIdentifier("passwordVisibilityButton")

        }
        .buttonStyle(.plain)
    }
    
    private func toggleVisibility() {
        withAnimation(.easeInOut(duration: 0.1)) {
            isSecure.toggle()
        }
    }
}
