//
//  AddMyListScreen.swift
//  iReminders
//
//  Created by Yery Castro on 7/6/24.
//

import SwiftUI

struct AddMyListScreen: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var listName: String = ""
    @State private var color: Color = .blue
    var myList: MyList? = nil
    
    var body: some View {
        VStack {
            Image(systemName: "line.3.horizontal.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(color)
            TextField("List name", text: $listName)
                .textFieldStyle(.roundedBorder)
                .padding([.leading, .trailing], 44)
            ColorPickerView(selectedColor: $color)
        }
        .onAppear {
            if let myList {
                listName = myList.name
                color = Color(hex: myList.colorCode)
            }
        }
        .navigationTitle("New List")
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
                    if let myList {
                        myList.name = listName
                        myList.colorCode = color.toHex() ?? ""
                    } else {
                        guard let hex = color.toHex() else { return }
                        let myList = MyList(name: listName, colorCode: hex)
                        context.insert(myList)
                    }
                    
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
        }
    }
}

#Preview { @MainActor in
    NavigationStack {
        AddMyListScreen()
    }
    .modelContainer(previewContainer)
}
