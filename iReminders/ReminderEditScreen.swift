//
//  ReminderEditScreen.swift
//  iReminders
//
//  Created by Yery Castro on 12/6/24.
//

import SwiftUI
import SwiftData

struct ReminderEditScreen: View {
    @Environment(\.dismiss) private var dismiss
    let reminder: Reminder
    @State private var title = ""
    @State private var notes = ""
    @State private var reminderDate: Date = .now
    @State private var reminderTime: Date = .now
    @State private var showCalender = false
    @State private var showTime = false
    
    private func updateReminder() {
        reminder.title = title
        reminder.notes = notes
        reminder.reminderDate = showCalender ? reminderDate : nil
        reminder.reminderTime = showTime ? reminderTime : nil
        
        NotificationManager.scheduleNotification(userData: UserData(title: reminder.title,
                                                                    body: reminder.notes,
                                                                    date: reminder.reminderDate,
                                                                    time: reminder.reminderTime))
    }
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $title)
                TextField("Notes", text: $notes)
            }
            
            Section {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.red)
                        .font(.title2)
                    Toggle(isOn: $showCalender) {
                        EmptyView()
                    }
                }
                .onChange(of: showTime) {
                    if showTime {
                        showCalender = true
                    }
                }
                
                if showCalender {
                    DatePicker("Select Date", selection: $reminderDate, in: .now..., displayedComponents: .date)
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundStyle(.blue)
                        .font(.title2)
                    Toggle(isOn: $showTime) {
                        EmptyView()
                    }
                }
                
                if showTime {
                    DatePicker("Select Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                }
            }
        }
        .onAppear {
            title = reminder.title
            notes = reminder.notes ?? ""
            reminderDate = reminder.reminderDate ?? Date()
            reminderTime = reminder.reminderTime ?? Date()
            showCalender = reminder.reminderDate != nil
            showTime = reminder.reminderTime != nil
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("Close")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    updateReminder()
                    dismiss()
                } label: {
                    Text("Done")
                }
                .disabled(!isFormValid)
            }
        }
    }
}

struct ReminderEditScreenContainer: View {
    @Query(sort: \Reminder.title) private var reminders: [Reminder]
    
    var body: some View {
        ReminderEditScreen(reminder: reminders[0])
    }
}

#Preview { @MainActor in
    NavigationStack {
        ReminderEditScreenContainer()
            .modelContainer(previewContainer)
    }
}
