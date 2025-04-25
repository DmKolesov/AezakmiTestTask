//
//  CameraError.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation

enum CameraError: Identifiable, LocalizedError {
    case simulatorCameraUnavailable, deviceUnavailable, permissionDenied, permissionRequired
    case saveFailed(Error), imageProcessingFailed, photoLibraryError(Error)
    case shareUnavailable, unknown

    var id: String { localizedDescription }
    var localizedDescription: String {
        switch self {
        case .simulatorCameraUnavailable: return "Камера недоступна в симуляторе"
        case .deviceUnavailable:         return "Камера недоступна"
        case .permissionDenied:          return "Доступ к камере запрещен"
        case .permissionRequired:        return "Разрешите доступ в настройках"
        case .saveFailed(let err):       return "Ошибка сохранения: \(err.localizedDescription)"
        case .imageProcessingFailed:     return "Ошибка обработки изображения"
        case .photoLibraryError(let e):  return "Ошибка загрузки фото: \(e.localizedDescription)"
        case .shareUnavailable:          return "Поделиться недоступно в симуляторе"
        case .unknown:                   return "Неизвестная ошибка"
        }
    }
}
