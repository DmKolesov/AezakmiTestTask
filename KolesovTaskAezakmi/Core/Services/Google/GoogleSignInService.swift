//
//  GoogleSignInService.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Combine
import SwiftUI
import GoogleSignIn

public protocol GoogleSignInServiceProtocol {
    func signIn() -> AnyPublisher<GoogleUserData, GoogleSignInError>
}

public final class GoogleSignInService: NSObject, GoogleSignInServiceProtocol {
  
    public override init() {
        super.init()

        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: "574422587657-0k83gfojn3l49mnr7qqfv8nchejokq86.apps.googleusercontent.com"
        )
    }
    
    public func signIn() -> AnyPublisher<GoogleUserData, GoogleSignInError> {
        Future { [weak self] promise in
            guard let self else {
                return promise(.failure(.unknown))
            }
            
            Task {
                do {
                    let result = try await self.performSignIn()
                    promise(.success(result))
                } catch {
                    promise(.failure(error as? GoogleSignInError ?? .unknown))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    @MainActor
    private func performSignIn() async throws -> GoogleUserData {
        guard let rootVC = topViewController() else {
            throw GoogleSignInError.presentationFailed
        }
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
        let user = result.user
        
        guard let idToken = user.idToken?.tokenString else {
            throw GoogleSignInError.missingData
        }
        
        return GoogleUserData(
            idToken: idToken,
            accessToken: user.accessToken.tokenString, // Больше не опциональный
            email: user.profile?.email ?? ""
        )
    }
    
    private func topViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first(where: \.isKeyWindow)?.rootViewController else {
            return nil
        }
        
        var topController = rootVC
        while let presented = topController.presentedViewController {
            topController = presented
        }
        return topController
    }
}
