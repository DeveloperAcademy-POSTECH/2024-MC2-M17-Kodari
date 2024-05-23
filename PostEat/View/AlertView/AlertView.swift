import Foundation
import UIKit
import UserNotifications
import SwiftUI

//알림 허용받기
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        // 앱 실행 시 사용자에게 알림 허용 권한을 받음
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        return true
    }
}

// Foreground(앱 켜진 상태)에서도 알림 오는 설정
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner])
    }
}

// LocalNotificationHelper.swift
class LocalNotificationHelper {
    static let shared = LocalNotificationHelper()
    
    private init() { }
    
    func setAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
    }
    
    //푸시 알림 보내기
    // PushNotificationHelper.swfit > PushNotificationHelper
    func pushNotification(title: String, body: String, seconds: Double, identifier: String) {
        // 1️⃣ 알림 내용, 설정
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body

        // 2️⃣ 조건(시간, 반복)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)

        // 3️⃣ 요청
        let request = UNNotificationRequest(identifier: identifier,
                                            content: notificationContent,
                                            trigger: trigger)

        // 4️⃣ 알림 등록
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    

}


struct AlertView: View {
    var body: some View {
//            LocalNotificationHelper.shared.pushNotification(title: "안녕하세요", body: "푸시 알림 테스트입니다.", seconds: 2, identifier: "PUSH_TEST")
        Button("push test Button") {
            
            LocalNotificationHelper.shared.pushNotification(title: "POST-EAT", body: "[중식 종료 알림을 눌러 인원을 기록해보세요.]", seconds: 2, identifier: "push test")
        }
        
    }

}

#Preview {
    AlertView()
}
