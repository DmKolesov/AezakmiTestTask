//
//  CustomTextField.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation
import SwiftUI

public struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var title: String
    var hasError: Bool
    var onCommit: (() -> Void)?
    
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
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .authTitleStyle()
                .accessibilityIdentifier("authLabel_\(title)")
            TextField(placeholder, text: $text, onCommit: {
                onCommit?()
            })
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .authFieldStyle(hasError: hasError)
            .accessibilityLabel(title)
        }
    }
}
