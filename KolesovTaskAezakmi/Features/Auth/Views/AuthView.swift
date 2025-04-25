//
//  AuthView.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation
import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel: AuthViewModel
    @State private var showForgotPassword = false
    @State private var navigateToRegistration = false
    @State private var showAlert = false
    @State private var alertType: AlertType = .info
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    init(
        repository: AuthRepositoryProtocol = AuthRepository(
            emailAuthService: FirebaseAuthService(),
            googleAuthService: GoogleSignInService(),
            emailCheckService: FirebaseEmailCheckService(),
            emailVerificationService: FirebaseEmailVerificationService()
        ),
        validator: ValidationProtocol = DefaultValidator()
    ) {
        _viewModel = StateObject(
            wrappedValue: AuthViewModel(
                validator: validator,
                repository: repository
            )
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection()
                    emailSection()
                    passwordSection()
                    signInButton()
                    forgotPasswordLink()
                    orDivider()
                    googleSignInButton()
                    signUpLink()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView(
                    isPresented: $showForgotPassword,
                    viewModel: viewModel
                )
            }
            .navigationDestination(isPresented: $navigateToRegistration) {
                RegisterView()
            }
            .onReceive(viewModel.$state) { handleStateChange($0) }
            .customAlert(
                isPresented: $showAlert,
                title: alertTitle,
                message: alertMessage,
                type: alertType
            )
        }
    }

    // MARK: Subviews
    private func headerSection() -> some View {
        Text("AEZAKMI Group Test Task")
            .font(.largeTitle.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func emailSection() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            CustomTextField(
                placeholder: "Enter your email",
                text: $viewModel.email,
                title: "Email",
                hasError: viewModel.emailValidationError != nil
            )
            if let error = viewModel.emailValidationError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .transition(.opacity)
            }
        }
    }

    private func passwordSection() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            CustomSecureField(
                placeholder: "Enter your password",
                text: $viewModel.password,
                title: "Password",
                hasError: viewModel.passwordValidationError != nil
            )
            if let error = viewModel.passwordValidationError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .transition(.opacity)
            }
        }
    }

    private func signInButton() -> some View {
        Button(action: viewModel.login) {
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
            } else {
                Text("Sign In")
            }
        }
        .primaryButton()
        .disabled(!viewModel.isLoginEnabled)
    }

    private func forgotPasswordLink() -> some View {
        Button("Forgot Password?") {
            showForgotPassword = true
        }
        .font(.subheadline)
        .foregroundColor(.accentColor)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func orDivider() -> some View {
        HStack {
            Divider()
            Text("OR")
                .font(.caption)
                .foregroundColor(.secondary)
            Divider()
        }
        .padding(.vertical, 8)
    }

    private func googleSignInButton() -> some View {
        Button(action: viewModel.signInWithGoogle) {
            Text("Continue with Google")
        }
        .googleSignInButton()
        .disabled(viewModel.isLoading)
    }

    private func signUpLink() -> some View {
        HStack {
            Text("Don't have an account?")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Button("Sign Up") {
                navigateToRegistration = true
            }
            .font(.subheadline)
            .foregroundColor(.accentColor)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private func handleStateChange(_ state: AuthViewModel.State) {
        switch state {
        case .success:
            alertType = .success
            alertTitle = "Success"
            alertMessage = "You have signed in successfully."
            showAlert = true
        case .needsEmailVerification:
            alertType = .info
            alertTitle = "Email Verification"
            alertMessage = "A verification link has been sent to your email."
            showAlert = true
        case .error(let error):
            alertType = .error
            alertTitle = "Error"
            alertMessage = error.localizedDescription
            showAlert = true
        default:
            break
        }
    }
}
