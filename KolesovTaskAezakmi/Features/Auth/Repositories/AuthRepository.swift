//
//  AuthRepository.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation
import Combine

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) -> AnyPublisher<User, AuthError>
    func signInWithGoogle() -> AnyPublisher<User, AuthError>
    func sendEmailVerification() -> AnyPublisher<Void, AuthError>
    func sendPasswordReset(email: String) -> AnyPublisher<Void, AuthError>
}

public final class AuthRepository: AuthRepositoryProtocol {
    
    // MARK: - Dependencies
    private let emailAuthService: FirebaseServiceProtocol
    private let googleAuthService: GoogleSignInServiceProtocol
    private let emailCheckService: EmailCheckHandling
    private let emailVerificationService: EmailVerificationHandling
    private let userMapper: FirebaseUserToDomainMapper
    private let googleUserMapper: GoogleUserDataToDTOMapper
    
    // MARK: - Initialization
    init(
        emailAuthService: FirebaseServiceProtocol,
        googleAuthService: GoogleSignInServiceProtocol,
        emailCheckService: EmailCheckHandling,
        emailVerificationService: EmailVerificationHandling,
        userMapper: FirebaseUserToDomainMapper = .init(),
        googleUserMapper: GoogleUserDataToDTOMapper = .init()
    ) {
        self.emailAuthService = emailAuthService
        self.googleAuthService = googleAuthService
        self.emailCheckService = emailCheckService
        self.emailVerificationService = emailVerificationService
        self.userMapper = userMapper
        self.googleUserMapper = googleUserMapper
    }
    
    // MARK: - Public Methods
    func login(email: String, password: String) -> AnyPublisher<User, AuthError> {
        emailCheckService.checkEmailExists(email: email)
            .mapError { error -> AuthError in
                if let authError = error as? AuthError {
                    return authError
                }
                return .firebaseError(error)
            }
            .flatMap { [weak self] exists -> AnyPublisher<User, AuthError> in
                guard let self = self else {
                    return Fail(error: .userNotLoggedIn).eraseToAnyPublisher()
                }
                return self.handleEmailExistence(exists: exists, email: email, password: password)
            }
            .eraseToAnyPublisher()
    }
    
    func signInWithGoogle() -> AnyPublisher<User, AuthError> {
        googleAuthService.signIn()
            .mapError { [weak self] error in
                self?.handleGoogleSignInError(error) ?? .googleSignInError(error)
            }
            .flatMap { [weak self] googleData -> AnyPublisher<User, AuthError> in
                guard let self = self else {
                    return Fail(error: .userNotLoggedIn).eraseToAnyPublisher()
                }
                return self.handleGoogleSignIn(data: googleData)
            }
            .eraseToAnyPublisher()
    }
    
    func sendEmailVerification() -> AnyPublisher<Void, AuthError> {
        emailVerificationService.sendEmailVerification()
            .mapError { .firebaseError($0) }
            .eraseToAnyPublisher()
    }
    
    func sendPasswordReset(email: String) -> AnyPublisher<Void, AuthError> {
           emailAuthService
               .sendPasswordReset(email: email)
               .mapError { error in
                   (error as? AuthError) ?? .firebaseError(error)
               }
               .eraseToAnyPublisher()
       }
    
    // MARK: - Private Methods
    private func handleEmailExistence(
        exists: Bool,
        email: String,
        password: String
    ) -> AnyPublisher<User, AuthError> {
        guard !exists else {
            return Fail(error: .emailAlreadyRegistered).eraseToAnyPublisher()
        }
        
        return emailAuthService.login(email: email, password: password)
            .map { [userMapper] dto in
                userMapper.map(input: dto)
            }
            .mapError { error -> AuthError in
                if let authError = error as? AuthError {
                    return authError
                }
                return .firebaseError(error)
            }
            .eraseToAnyPublisher()
    }
    
    private func handleGoogleSignIn(data: GoogleUserData) -> AnyPublisher<User, AuthError> {
        let googleUserDTO = googleUserMapper.map(input: data)
        
        return emailAuthService.loginWithGoogle(googleUser: googleUserDTO)
            .flatMap { [weak self] userDTO -> AnyPublisher<User, AuthError> in
                guard let self = self else {
                    return Fail(error: .userNotLoggedIn).eraseToAnyPublisher()
                }
                return self.handleUserVerification(userDTO: userDTO)
            }
            .eraseToAnyPublisher()
    }
    
    private func handleUserVerification(userDTO: FirebaseUserDTO) -> AnyPublisher<User, AuthError> {
        emailVerificationService.sendEmailVerification()
            .map { [userMapper] _ in
                userMapper.map(input: userDTO)
            }
            .mapError { .firebaseError($0) }
            .eraseToAnyPublisher()
    }
    
    private func handleGoogleSignInError(_ error: Error) -> AuthError {
        if let googleError = error as? GoogleSignInError {
            switch googleError {
            case .cancelled:
                return .googleSignInError(NSError(
                    domain: "GoogleSignIn",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Authorization cancelled"]
                ))
            default:
                return .googleSignInError(googleError)
            }
        }
        return .googleSignInError(error)
    }
}



