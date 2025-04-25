//
//  RegisterRepository.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation
import Combine

protocol RegisterRepositoryProtocol {
    func register(email: String, password: String) -> AnyPublisher<User, AuthError>
}

final class RegisterRepository: RegisterRepositoryProtocol {
    private let authService: FirebaseServiceProtocol
    private let emailVerificationService: EmailVerificationHandling
    private let userMapper: FirebaseUserToDomainMapper
    
    init(authService: FirebaseServiceProtocol,
         emailVerificationService: EmailVerificationHandling,
         userMapper: FirebaseUserToDomainMapper = .init()) {
        self.authService = authService
        self.emailVerificationService = emailVerificationService
        self.userMapper = userMapper
    }
    
    func register(email: String, password: String) -> AnyPublisher<User, AuthError> {
        authService.register(email: email, password: password)
            .flatMap { [weak self] userDTO -> AnyPublisher<User, AuthError> in
                guard let self = self else {
                    return Fail(error: .userNotLoggedIn).eraseToAnyPublisher()
                }
                return self.handleEmailVerification(userDTO: userDTO)
            }
            .eraseToAnyPublisher()
    }
    
    private func handleEmailVerification(userDTO: FirebaseUserDTO) -> AnyPublisher<User, AuthError> {
        emailVerificationService.sendEmailVerification()
            .map { [userMapper] _ in
                userMapper.map(input: userDTO)
            }
            .mapError { .firebaseError($0) }
            .eraseToAnyPublisher()
    }
}

