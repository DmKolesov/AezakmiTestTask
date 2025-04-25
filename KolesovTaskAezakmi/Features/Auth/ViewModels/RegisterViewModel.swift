//
//  RegisterViewModel.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Combine
import SwiftUI

final class RegisterViewModel: ObservableObject {
    enum State {
        case idle, loading, success(User), error
    }
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var state: State = .idle
    @Published var errorMessage: String?
    @Published var emailValidationError: String?
    @Published var passwordValidationError: String?
    @Published var showError = false
    
    private let repository: RegisterRepositoryProtocol
    private let validator: ValidationProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: RegisterRepositoryProtocol,
         validator: ValidationProtocol) {
        self.repository = repository
        self.validator = validator
        setupValidation()
    }
    
    var isRegisterEnabled: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        emailValidationError == nil &&
        passwordValidationError == nil &&
        !isLoading
    }
    
    var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }
    
    func register() {
        state = .loading
        errorMessage = nil
        
        repository.register(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.handleError(error)
                }
            } receiveValue: { [weak self] user in
                self?.state = .success(user)
            }
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: AuthError) {
        errorMessage = error.localizedDescription
        showError = true
        state = .error
    }
    
    private func setupValidation() {
        $email
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { [weak self] email in
                self?.validator.validateEmail(email)?.localizedDescription
            }
            .assign(to: &$emailValidationError)
        
        Publishers.CombineLatest($password, $confirmPassword)
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { [weak self] password, confirmPassword in
                if password != confirmPassword {
                    return "Passwords do not match"
                }
                return self?.validator.validatePassword(password)?.localizedDescription
            }
            .assign(to: &$passwordValidationError)
    }
}
