//
//  AuthError.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation

enum AuthError: Error, LocalizedError {
    case validationFailed([ValidationError])
    case emailAlreadyRegistered
    case firebaseError(Error)
    case googleSignInError(Error)
    case userNotLoggedIn
    
    public var errorDescription: String? {
        switch self {
        case .validationFailed(let errors):
            return errors.map { $0.localizedDescription }.joined(separator: "\n")
        case .emailAlreadyRegistered:
            return "This email is already registered"
        case .firebaseError(let error):
            return "Authentication error: \(error.localizedDescription)"
        case .googleSignInError(let error):
            return "Google sign-in error: \(error.localizedDescription)"
        case .userNotLoggedIn:
            return "User is not logged in"
        }
    }
}

