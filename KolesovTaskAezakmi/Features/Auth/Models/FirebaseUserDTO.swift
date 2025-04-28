//
//  FirebaseUserDTO.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

public struct FirebaseUserDTO {
    public let uid: String
    public let email: String
    public let isEmailVerified: Bool

    init(from firebaseUser: FirebaseAuth.User) {
        self.uid = firebaseUser.uid
        self.email = firebaseUser.email ?? ""
        self.isEmailVerified = firebaseUser.isEmailVerified
    }
}

public struct GoogleUserDTO {
    public let idToken: String
    public let accessToken: String
}

