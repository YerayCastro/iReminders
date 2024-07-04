//
//  MyListsScreen.swift
//  iReminders
//
//  Created by Yery Castro on 7/6/24.
//

import SwiftUI
import SwiftData

enum ReminderStatsType: Int, Identifiable {
    case today
    case scheduled
    case all
    case completed
    
    var id: Int {
        self.rawValue
    }
    
    var title: String {
        switch self {
        case .today:
            "Today"
        case .scheduled:
            "Scheduled"
        case .all:
            "All"
        case .completed:
            "Completed"
        }
    }
}

struct MyListsScreen: View {
    @Query private var myLists: [MyList]
    @State private var isPresented: Bool = false
    @State private var selectedList: MyList?
    @State private var actionSheet: MyListScreenSheets?
    @State private var reminderStastsType: ReminderStatsType?
    @Query private var reminders: [Reminder]
    
    enum MyListScreenSheets: Identifiable {
        case newList
        case editList(MyList)
        
        var id: Int {
            switch self {
            case .newList:
                return 1
            case .editList(let myList):
                return myList.hashValue
            }
        }
    }
    
    private var inCompleteReminders: [Reminder] {
        reminders.filter { !$0.isCompleted }
    }
    
    private var todaysReminders: [Reminder] {
        reminders.filter {
            guard let reminderDate = $0.reminderDate else {
                return false
            }
            return reminderDate.isToday && !$0.isCompleted
        }
    }
    
    private var scheduledReminders: [Reminder] {
        reminders.filter {
            $0.reminderDate != nil && !$0.isCompleted
        }
    }
    
    private var completedReminders: [Reminder] {
        reminders.filter { $0.isCompleted }
    }
    
    private func reminders(for type: ReminderStatsType) -> [Reminder] {
        switch type {
        case .today:
            return todaysReminders
        case .scheduled:
            return scheduledReminders
        case .all:
            return inCompleteReminders
        case .completed:
            return completedReminders
        }
    }
    
    var body: some View {
        List {
            VStack {
                HStack {
                    ReminderStatsView(icon: "calendar", title: "Today", count: todaysReminders.count)
                        .onTapGesture {
                            reminderStastsType = .today
                        }
                    ReminderStatsView(icon: "calendar.circle.fill", title: "Sheduled", count: scheduledReminders.count)
                        .onTapGesture {
                            reminderStastsType = .scheduled
                        }
                }
                HStack {
                    ReminderStatsView(icon: "try.circle.fill", title: "All", count: inCompleteReminders.count)
                        .onTapGesture {
                            reminderStastsType = .all
                        }
                    ReminderStatsView(icon: "checkmark.circle.fill", title: "Completed", count: completedReminders.count)
                        .onTapGesture {
                            reminderStastsType = .completed
                        }
                }
            }
            ForEach(myLists) { myList in
                NavigationLink(value: myList) {
                    MyListCellView(myList: myList)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedList = myList
                        }
                        .onLongPressGesture(minimumDuration: 0.5) {
                            actionSheet = .editList(myList)
                        }
                }
            }
            Button {
                actionSheet = .newList
            } label: {
                Text("Add List")
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .listRowSeparator(.hidden)
            .navigationTitle("My Lists")
            .navigationDestination(item: $selectedList) { myList in
                MyListDetailScreen(myList: myList)
            }
            .navigationDestination(item: $reminderStastsType, destination: { reminderStatsType in
                NavigationStack {
                    ReminderListView(reminders: reminders(for: reminderStatsType))
                        .navigationTitle(reminderStatsType.title)
                }
            })
        }
        .listStyle(.plain)
        .sheet(item: $actionSheet) { actionSheet in
            switch actionSheet {
            case .newList:
                NavigationStack {
                    AddMyListScreen()
                }
            case .editList(let myList):
                NavigationStack {
                    AddMyListScreen(myList: myList)
                }
            }
        }
    }
}

#Preview { @MainActor in
    NavigationStack {
        MyListsScreen()
    }
    .modelContainer(previewContainer)
}


