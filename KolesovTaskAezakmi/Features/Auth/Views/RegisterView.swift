//
//  RegisterView.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import SwiftUI
import Combine

struct RegisterView: View {
    @StateObject private var viewModel: RegisterViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var navigateToPhotoEditor = false
    
    private enum Field: Hashable {
        case email, password, confirm
    }

    init(
        repository: RegisterRepositoryProtocol = RegisterRepository(
            authService: FirebaseAuthService(),
            emailVerificationService: FirebaseEmailVerificationService(),
            userMapper: FirebaseUserToDomainMapper()
        ),
        validator: ValidationProtocol = DefaultValidator()
    ) {
        _viewModel = StateObject(
            wrappedValue: RegisterViewModel(
                repository: repository,
                validator: validator
            )
        )
    }

    var body: some View {
        NavigationStack {
            NavigationLink(destination: PhotoEditingView(), isActive: $navigateToPhotoEditor) {
                EmptyView()
            }
            ScrollView {
                VStack(spacing: 24) {
                    headerSection()
                    emailSection()
                    passwordSection()
                    confirmPasswordSection()
                    registerButton()
                    signInLink()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onReceive(viewModel.$state) { handleStateChange($0) }
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK") {
                    if case .success = viewModel.state {
                        navigateToPhotoEditor = true
                    }
                }
                Button("Close", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }

    // MARK: - Subviews
    private func headerSection() -> some View {
        Text("Create Account")
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
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .focused($focusedField, equals: .email)
            
            if let error = viewModel.emailValidationError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }

    private func passwordSection() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            CustomSecureField(
                placeholder: "Enter password",
                text: $viewModel.password,
                title: "Password",
                hasError: viewModel.passwordValidationError != nil
            )
            .textContentType(.newPassword)
            .focused($focusedField, equals: .password)
            
            if let error = viewModel.passwordValidationError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }

    private func confirmPasswordSection() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            CustomSecureField(
                placeholder: "Confirm password",
                text: $viewModel.confirmPassword,
                title: "Confirm Password",
                hasError: viewModel.passwordValidationError != nil
            )
            .textContentType(.newPassword)
            .focused($focusedField, equals: .confirm)
            
            if let error = viewModel.passwordValidationError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }

    private func registerButton() -> some View {
        Button(action: submitRegistration) {
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
            } else {
                Text("Register")
            }
        }
        .primaryButton()
        .disabled(!viewModel.isRegisterEnabled)
    }

    private func signInLink() -> some View {
        HStack {
            Text("Already have an account?")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Button("Sign In") {
                dismiss()
            }
            .font(.subheadline)
            .foregroundColor(.accentColor)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    // MARK: - Actions
    private func submitRegistration() {
        focusedField = nil
        viewModel.register()
    }

    private func handleStateChange(_ state: RegisterViewModel.State) {
        switch state {
        case .success:
            alertTitle = "Success"
            alertMessage = "You have registered successfully."
            showAlert = true
        case .error:
            alertTitle = "Error"
            alertMessage = viewModel.errorMessage ?? "Unknown error"
            showAlert = true
        case .loading, .idle:
            break
        }
    }
}
