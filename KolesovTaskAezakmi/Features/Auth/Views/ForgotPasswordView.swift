//
//  ForgotPasswordView.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: AuthViewModel
    @State private var email = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Reset Password")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)

                    CustomTextField(
                        placeholder: "Enter your email",
                        text: $email,
                        title: "Email",
                        hasError: viewModel.resetError != nil
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .onChange(of: email) { newValue in
                        viewModel.resetError = viewModel.validator.validateEmail(newValue)?.localizedDescription
                    }

                    if let error = viewModel.resetError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button(action: { viewModel.resetPassword(email: email) }) {
                        Text("Send Reset Link")
                            .frame(maxWidth: .infinity)
                    }
                    .primaryButton()
                    .disabled(email.isEmpty || viewModel.resetError != nil)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Forgot Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
            }
            .onReceive(viewModel.$didSendReset) { sent in
                if sent { isPresented = false }
            }
        }
        .onAppear {
            viewModel.resetError = nil
            email = ""
        }
    }
}
