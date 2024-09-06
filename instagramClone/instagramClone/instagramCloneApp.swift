//
//  instagramCloneApp.swift
//  instagramClone
//
//  Created by 유성열 on 9/1/24.
//
// MARK: - Instagram Clone 앱

import SwiftUI
import FirebaseCore

// MARK: 앱이 실행될 때 가장 먼저 실행되는 코드 영역(앱 생명주기 이벤트를 처리하기 위한 패턴)
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure() // 파이어베이스 실행

    return true
  }
}

@main
struct instagramCloneApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate // 파이어베이스 설정(델리게이트)

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
