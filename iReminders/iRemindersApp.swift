//
//  iRemindersApp.swift
//  iReminders
//
//  Created by Yery Castro on 7/6/24.
//

import SwiftUI
import UserNotifications

@main
struct iRemindersApp: App {
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in
            
        }
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MyListsScreen()
            }
            .modelContainer(for: MyList.self)
        }
    }
}
