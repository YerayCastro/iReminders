//
//  PreviewContainer.swift
//  iReminders
//
//  Created by Yery Castro on 7/6/24.
//

import Foundation
import SwiftData

@MainActor
var previewContainer: ModelContainer = {
    let container = try! ModelContainer(for: MyList.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    for myList in SampleData.myList {
        container.mainContext.insert(myList)
        myList.reminders = SampleData.Reminders
    }
    return container
}()

struct SampleData {
    static var myList: [MyList] {
        return [MyList(name: "Reminders", colorCode: "#2ecc71"), MyList(name: "Backlog", colorCode: "#9b59b6")]
    }
    
    static var Reminders: [Reminder] {
        return [Reminder(title: "Reminder 1", notes: "This is reminder 1 notes!", reminderDate: Date(), remminderTime: Date()), Reminder(title: "Reminder 2", notes: "This is a reminder 2 note")]
    }
}
