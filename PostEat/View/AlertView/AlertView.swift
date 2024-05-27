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
            completionHandler: { granted, error in
                            if let error = error {
                                print("Error requesting notification AppDelegate: \(error)")
                            } else {
                                print("Notification permission granted: \(granted)")
                            }
                        } // just 에러나면 보여주기 위한 print
        )
        //알림 예약
        LocalNotificationHelper
            .shared
            .pushNotification(title: "POST-EAT",
                              body: "[조식 종료] 알림을 눌러 인원을 기록해보세요.",
                              hour: 9,
                              minute: 30,
                              identifier: "M_noti")
        
        LocalNotificationHelper
            .shared
            .pushNotification(title: "POST-EAT",
                              body: "[중식 종료] 알림을 눌러 인원을 기록해보세요.",
                              hour: 13,
                              minute: 30,
                              identifier: "L_noti")
        
        LocalNotificationHelper
            .shared
            .pushNotification(title: "POST-EAT",
                              body: "[석식 종료] 알림을 눌러 인원을 기록해보세요.",
                              hour: 19,
                              minute: 0,
                              identifier: "D_noti")
    
        return true
    }
}

// Foreground(앱 켜진 상태)에서도 알림 오는 설정
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            HapticHelper.shared.impact(style: .medium)
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
            completionHandler: { granted, error in
                            if let error = error {
                                print("Error requesting notification authorization: \(error)")
                            } else {
                                print("Notification permission granted: \(granted)")
                            } // just 에러나면 보여주기 위한 print
                        }
        )
    }
    
    //푸시 알림 보내기
    /// 호출 시점을 기점 seconds초 이후에 Notification을 보냅니다.
        ///
        /// - Parameters:
        ///   - title: Push Notification에 표시할 제목입니다.
        ///   - body: Push Notification에 표시할 본문입니다.
        ///   - seconds: 현재로부터 seconds초 이후에 알림을 보냅니다. 0보다 커야하며 1이하 실수도 가능합니다. (파라미터 변경해서 세컨드는 없애고 hour,minute이 생겼음.
        ///   - identifier: 실행 취소, 알림 구분 등에 사용되는 식별자입니다. "TEST_NOTI" 형식으로 작성해주세요.
    func pushNotification(title: String, body: String, hour: Int, minute: Int, identifier: String) {
       
        assert(hour >= 0 || hour <= 24, "시간은 0이상 24이하로 입력해주세요.")
        
        // 1️⃣ 알림 내용, 설정
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.sound = UNNotificationSound.default
        
        //  ✅ 알림을 보낼 시간 (24시간 형식) 주기설정
        var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
        

        // 2️⃣ 조건(시간, 반복)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true) // ✅ true로 하면 특정 주기로 반복적으로 알람을 보낼 수 있음.
          
        // 3️⃣ 요청
        let request = UNNotificationRequest(identifier: identifier,
                                            content: notificationContent,
                                            trigger: trigger)

        // 4️⃣ 알림 등록
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            } else {
                print("Notification scheduled: \(identifier)")
            }
        }
    }
    

}

//햅틱(진동) 넣기
class HapticHelper {
    
    static let shared = HapticHelper()
    
    private init() { }
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}


struct AlertView: View {
    var body: some View {
        Text("post-eat 알림 설정 완료^^")
            .padding()
        
    }

}

#Preview {
    AlertView()
}
