//
//  ReminderListView.swift
//  iReminders
//
//  Created by Yery Castro on 21/6/24.
//

import SwiftUI
import SwiftData

struct ReminderListView: View {
    @Environment(\.modelContext) private var context
    let reminders: [Reminder]
    @State private var selectedReminder: Reminder? = nil
    @State private var showReminderEditScreen = false
    @State private var reminderIdAndDelay: [PersistentIdentifier: Delay] = [: ]
    
    private func deleteReminder(_ indexSet: IndexSet) {
        guard let index = indexSet.last else { return }
        let reminder = reminders[index]
        context.delete(reminder)
    }
    
    var body: some View {
        List {
            ForEach(reminders) { reminder in
                ReminderCellView(reminder: reminder) { event in
                    switch event {
                    case .onChecked(let reminder, let checked):
                        var delay = reminderIdAndDelay[reminder.persistentModelID]
                        if let delay {
                            delay.cancel()
                            reminderIdAndDelay.removeValue(forKey: reminder.persistentModelID)
                        } else {
                            delay = Delay()
                            reminderIdAndDelay[reminder.persistentModelID] = delay
                            delay?.performWork {
                                reminder.isCompleted = checked
                            }
                        }
                    case .onSelect(let reminder):
                        selectedReminder = reminder
                    }
                }
            }
            .onDelete(perform: deleteReminder)
        }
        .sheet(item: $selectedReminder) { selectedReminder in
            NavigationStack {
                ReminderEditScreen(reminder: selectedReminder)
            }
        }
    }
}

//#Preview {
//    ReminderListView()
//}
