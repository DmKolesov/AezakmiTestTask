//
//  KolesovTaskAezakmiApp.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 24.04.2025.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct KolesovTaskAezakmiApp: App {

  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      NavigationView {
        AuthView()
      }
    }
  }
}
