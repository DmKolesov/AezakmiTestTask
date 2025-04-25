//
//  Publisher+Ext.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation
import Combine

extension Publisher where Failure == Error {
    func mapToAuthError() -> AnyPublisher<Output, AuthError> {
        self.mapError { error -> AuthError in
            if let authError = error as? AuthError {
                return authError
            }
            return .firebaseError(error)
        }
        .eraseToAnyPublisher()
    }
}

