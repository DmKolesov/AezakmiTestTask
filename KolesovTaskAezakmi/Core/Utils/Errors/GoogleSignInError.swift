//
//  GoogleSignInError.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation

public enum GoogleSignInError: Error, LocalizedError {
    case presentationFailed
    case cancelled
    case missingData
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .presentationFailed: return "Failed to show authorization window"
        case .cancelled: return "Authorization cancelled"
        case .missingData: return "Missing required Google data"
        case .unknown: return "Unknown error"
        }
    }
}
