//
//  Mappers.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

public protocol Mapper {
    associatedtype Input
    associatedtype Output
    func map(input: Input) -> Output
}

// MARK: - Firebase → Domain
 struct FirebaseUserToDomainMapper: Mapper {
    public init() {}
    
    public func map(input dto: FirebaseUserDTO) -> User {
        User(
            id: dto.uid,
            email: dto.email,
            isEmailVerified: dto.isEmailVerified
        )
    }
}

// MARK: - Google Data → DTO
public struct GoogleUserDataToDTOMapper: Mapper {
    public init() {}
    
    public func map(input: GoogleUserData) -> GoogleUserDTO {
        GoogleUserDTO(
            idToken: input.idToken,
            accessToken: input.accessToken
        )
    }
}

// MARK: - Google SDK → Data Model
public struct GoogleSDKToDataMapper: Mapper {
    public init() {}
    
    public func map(input sdkUser: GIDGoogleUser) -> GoogleUserData {
        guard let idToken = sdkUser.idToken?.tokenString else {
            fatalError("Missing required ID Token from Google")
        }
        
        return GoogleUserData(
            idToken: idToken,
            accessToken: sdkUser.accessToken.tokenString,
            email: sdkUser.profile?.email ?? ""
        )
    }
}

