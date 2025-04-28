//
//  AuthViewModel.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation
import Combine

final class AuthViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case success(User)
        case error(AuthError)
    }

    @Published var email = ""
    @Published var password = ""
    @Published var state: State = .idle
    @Published var emailValidationError: String?
    @Published var passwordValidationError: String?
    @Published var currentUser: User?
    @Published var resetError: String?
    @Published var didSendReset = false

    private let repository: AuthRepositoryProtocol
    let validator: ValidationProtocol
    private var cancellables = Set<AnyCancellable>()

    init(
        validator: ValidationProtocol,
        repository: AuthRepositoryProtocol) {
        self.validator = validator
        self.repository = repository
        setupValidation()
    }

    var isLoginEnabled: Bool {
        !email.isEmpty && !password.isEmpty && emailValidationError == nil && passwordValidationError == nil && !isLoading
    }

    var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }

    func login() {
        state = .loading
        repository.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .error(error)
                }
            } receiveValue: { [weak self] user in
                self?.currentUser = user
                self?.handleAuthResult(user: user)
            }
            .store(in: &cancellables)
    }

    func signInWithGoogle() {
        state = .loading
        repository.signInWithGoogle()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .error(error)
                }
            } receiveValue: { [weak self] user in
                self?.currentUser = user
                self?.handleAuthResult(user: user)
            }
            .store(in: &cancellables)
    }

    func resetPassword(email: String) {
        resetError = nil
        didSendReset = false
        repository.sendPasswordReset(email: email)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.resetError = error.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                self?.didSendReset = true
            }
            .store(in: &cancellables)
    }

    func sendVerificationEmail() {
        repository.sendEmailVerification()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .error(error)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }

    private func handleAuthResult(user: User) {
// закоменнченный метод для верификации пользователя
        state = .success(user)
//        if user.isEmailVerified {
//            state = .success(user)
//        } else {
//            state = .needsEmailVerification(user)
//            sendVerificationEmail()
//        }
    }

    private func setupValidation() {
        $email
            .dropFirst()
            .map { [weak self] in self?.validator.validateEmail($0) }
            .sink { [weak self] in self?.emailValidationError = $0?.localizedDescription }
            .store(in: &cancellables)

        $password
            .dropFirst()
            .map { [weak self] in self?.validator.validatePassword($0) }
            .sink { [weak self] in self?.passwordValidationError = $0?.localizedDescription }
            .store(in: &cancellables)
    }
}
