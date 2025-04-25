//
//  CustomAlertModifier.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation
import SwiftUI

enum AlertType {
    case success
    case error
    case info
    
    var tintColor: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .info: return .blue
        }
    }
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
}

struct CustomAlert: View {
    let title: String
    let message: String
    let alertType: AlertType
    var onDismiss: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: alertType.icon)
                .font(.system(size: 48))
                .foregroundColor(alertType.tintColor)
            
            Text(title)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button("OK", action: {
                onDismiss?()
            })
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(alertType.tintColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top, 10)
        }
        .padding()
        .frame(width: 280)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
        .transition(.scale.combined(with: .opacity))
    }
}

struct CustomAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let alertType: AlertType
    var onDismiss: (() -> Void)? = nil
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .zIndex(1)
                
                CustomAlert(
                    title: title,
                    message: message,
                    alertType: alertType,
                    onDismiss: {
                        isPresented = false
                        onDismiss?()
                    }
                )
                .zIndex(2)
            }
        }
    }
}

extension View {
    func customAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        type: AlertType,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            CustomAlertModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                alertType: type,
                onDismiss: onDismiss
            )
        )
    }
}
