//
//  FirebaseEmailCheckService.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation
import Combine
import Firebase

protocol EmailCheckHandling {
    func checkEmailExists(email: String) -> AnyPublisher<Bool, Error>
}

final class FirebaseEmailCheckService: EmailCheckHandling {
    func checkEmailExists(email: String) -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { promise in
            Auth.auth().fetchSignInMethods(forEmail: email) { methods, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(!(methods?.isEmpty ?? true)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

