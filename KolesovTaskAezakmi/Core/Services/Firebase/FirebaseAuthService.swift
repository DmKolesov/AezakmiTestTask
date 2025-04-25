//
//  FirebaseAuthService.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation
import Combine
import FirebaseAuth

protocol FirebaseServiceProtocol {
    func login(email: String, password: String) -> AnyPublisher<FirebaseUserDTO, AuthError>
    func loginWithGoogle(googleUser: GoogleUserDTO) -> AnyPublisher<FirebaseUserDTO, AuthError>
    func register(email: String, password: String) -> AnyPublisher<FirebaseUserDTO, AuthError>
    func sendPasswordReset(email: String) -> AnyPublisher<Void, Error>
}

final class FirebaseAuthService: FirebaseServiceProtocol {
    
    private let auth: Auth
    
    init(auth: Auth = .auth()) {
        self.auth = auth
    }
    
    func login(email: String, password: String) -> AnyPublisher<FirebaseUserDTO, AuthError> {
        Future<AuthDataResult, Error> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let result = result {
                    promise(.success(result))
                } else {
                    promise(.failure(error ?? NSError(domain: "Unknown", code: -1)))
                }
            }
        }
        .mapError { AuthError.firebaseError($0) }
        .map(\.user)
        .map(FirebaseUserDTO.init)
        .eraseToAnyPublisher()
    }

    func loginWithGoogle(googleUser: GoogleUserDTO) -> AnyPublisher<FirebaseUserDTO, AuthError> {
        let credential = GoogleAuthProvider.credential(
            withIDToken: googleUser.idToken,
            accessToken: googleUser.accessToken
        )

        return Future<AuthDataResult, Error> { promise in
            Auth.auth().signIn(with: credential) { result, error in
                if let result = result {
                    promise(.success(result))
                } else {
                    promise(.failure(error ?? NSError(domain: "Unknown", code: -1)))
                }
            }
        }
        .mapError { AuthError.firebaseError($0) }
        .map(\.user)
        .map(FirebaseUserDTO.init)
        .eraseToAnyPublisher()
    }
    
    func register(email: String, password: String) -> AnyPublisher<FirebaseUserDTO, AuthError> {
           Future<AuthDataResult, Error> { [weak self] promise in
               self?.auth.createUser(withEmail: email, password: password) { result, error in
                   if let error = error {
                       promise(.failure(error))
                   } else if let result = result {
                       promise(.success(result))
                   } else {
                       promise(.failure(NSError(domain: "Auth", code: -1)))
                   }
               }
           }
           .map { FirebaseUserDTO(from: $0.user) }
           .mapError { AuthError.firebaseError($0) }
           .eraseToAnyPublisher()
       }
    
    func sendPasswordReset(email: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            self?.auth.sendPasswordReset(withEmail: email) { error in
                if let err = error {
                    promise(.failure(err))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
}

