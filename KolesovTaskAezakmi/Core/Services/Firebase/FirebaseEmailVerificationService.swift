//
//  FirebaseEmailVerificationService.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation
import Combine
import Firebase

protocol EmailVerificationHandling {
    func sendEmailVerification() -> AnyPublisher<Void, Error>
}

final class FirebaseEmailVerificationService: EmailVerificationHandling {
    func sendEmailVerification() -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            guard let user = Auth.auth().currentUser else {
                return promise(.failure(NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            }
            
            user.sendEmailVerification { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}


