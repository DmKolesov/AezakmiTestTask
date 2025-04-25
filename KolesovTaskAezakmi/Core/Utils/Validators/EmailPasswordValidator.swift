//
//  EmailPasswordValidator.swift
//  TestTask(Aezakmi)
//
//  Created by Dima Kolesov on 24.04.2025.
//

import Foundation
import os.log

protocol EmailValidatable {
    func validateEmail(_ email: String) -> ValidationError?
}

protocol PasswordValidatable {
    func validatePassword(_ password: String) -> ValidationError?
}

typealias ValidationProtocol = EmailValidatable & PasswordValidatable

final class DefaultValidator: ValidationProtocol {
    private let logger = OSLog(
        subsystem: "com.example.validation",
        category: "Validation"
    )
    
    func validateEmail(_ email: String) -> ValidationError? {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return .emptyEmail
        }
        let isValid = Predicates.email.evaluate(with: trimmed)
//        os_log("Email validation: %@ - %@",
//               log: logger,
//               type: .debug,
//               trimmed,
//               isValid ? "Valid" : "Invalid")
        return isValid ? nil : .invalidEmailFormat
    }
    
    func validatePassword(_ password: String) -> ValidationError? {
        guard !password.isEmpty else {
            return .emptyPassword
        }
        var reasons = [ValidationError.PasswordWeaknessReason]()
        if password.count < 6 {
            reasons.append(.tooShort(minLength: 6))
        }
        if password.rangeOfCharacter(from: .decimalDigits) == nil {
            reasons.append(.noDigits)
        }
        if password.rangeOfCharacter(from: .uppercaseLetters) == nil {
            reasons.append(.noUppercaseLetters)
        }
        return reasons.isEmpty ? nil : .weakPassword(reasons: reasons)
    }
}

// MARK: - Validation Errors

enum ValidationError: LocalizedError {
    case emptyEmail
    case invalidEmailFormat
    case emptyPassword
    case weakPassword(reasons: [PasswordWeaknessReason])
    case passwordsDoNotMatch
    
    enum PasswordWeaknessReason {
        case tooShort(minLength: Int)
        case noDigits
        case noUppercaseLetters
        
        var localizedDescription: String {
            switch self {
            case .tooShort(let min):
                return String(
                    format: NSLocalizedString(
                        "validation.error.password.tooShort",
                        value: "Minimum %d characters",
                        comment: ""),
                    min
                )
            case .noDigits:
                return NSLocalizedString(
                    "validation.error.password.noDigits",
                    value: "Requires at least 1 digit",
                    comment: ""
                )
            case .noUppercaseLetters:
                return NSLocalizedString(
                    "validation.error.password.noUppercaseLetters",
                    value: "Requires at least 1 uppercase letter",
                    comment: ""
                )
            }
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .emptyEmail:
            return NSLocalizedString(
                "validation.error.email.empty",
                value: "Email cannot be empty",
                comment: ""
            )
        case .invalidEmailFormat:
            return NSLocalizedString(
                "validation.error.email.invalidFormat",
                value: "Invalid email format",
                comment: ""
            )
        case .emptyPassword:
            return NSLocalizedString(
                "validation.error.password.empty",
                value: "Password cannot be empty",
                comment: ""
            )
        case .weakPassword(let reasons):
            return reasons.map { $0.localizedDescription }.joined(separator: "\n")
        case .passwordsDoNotMatch:
            return NSLocalizedString(
                "validation.error.password.mismatch",
                value: "Passwords do not match",
                comment: ""
            )
        }
    }
}

// MARK: - Predicates

private enum RegexPattern {
    static let email = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}"#
}

private enum Predicates {
    static let email: NSPredicate = {
        NSPredicate(format: "SELF MATCHES %@", RegexPattern.email)
    }()
}

