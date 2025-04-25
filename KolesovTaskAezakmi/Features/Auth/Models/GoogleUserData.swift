//
//  GoogleUserData.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation

public struct GoogleUserData {
    public let idToken: String
    public let accessToken: String
    public let email: String
    
    public init(idToken: String, accessToken: String, email: String) {
         self.idToken = idToken
         self.accessToken = accessToken
         self.email = email
     }
}
