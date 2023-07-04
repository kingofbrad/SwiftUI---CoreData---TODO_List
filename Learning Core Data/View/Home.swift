//
//  Home.swift
//  Learning Core Data
//
//  Created by Bradlee King on 30/06/2023.
//

import SwiftUI

struct Home: View {
    @Environment(\.self) private var env
    @State private var filterDate: Date = .init()
    @State private var showPendingTasks: Bool = true
    @State private var showCompletedTasks: Bool = true

    var body: some View {
        List {
            DatePicker(selection: $filterDate, displayedComponents: [.date]) {
                
            }
            .labelsHidden()
            .datePickerStyle(.graphical)
            
            DisclosureGroup(isExpanded: $showPendingTasks) {
                CustomFilteringDataView(displayPendingTask: true, filterDate: filterDate) {
                    TaskRow(task: $0, isPendingTask: true)
                }
            } label: {
                Text("Pending Tasks")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            DisclosureGroup(isExpanded: $showCompletedTasks) {
                CustomFilteringDataView(displayPendingTask: false, filterDate: filterDate) {
                    TaskRow(task: $0, isPendingTask: false)
                }
            } label: {
                Text("Completed Tasks")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    do {
                        let task = Task(context: env.managedObjectContext)
                        task.id = .init()
                        task.date = filterDate
                        task.title = ""
                        task.isCompleted = false
                        
                        try env.managedObjectContext.save()
                        showPendingTasks = true
                    } catch {
                        print(error.localizedDescription)
                    }
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                        Text("New Task")
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct TaskRow : View {
    var task: Task
    var isPendingTask: Bool
    @Environment(\.self) private var env
    @FocusState private var showKeyboard: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                
            } label: {
                Image(systemName: task.isCompleted ? "check.circle.fill" : "circle")
                    .font(.title)
                    .foregroundColor(.blue)
            }
            VStack(alignment: .leading, spacing: 4) {
                TextField("Task Title", text: .init(get: {
                    return task.title ?? ""
                }, set: { value in
                    task.title = value
                }))
                .focused($showKeyboard)
                .onSubmit {
                    removeEmptyTask()
                    save()
                }
                Text((task.date ?? .init()).formatted(date: .omitted, time: .shortened))
                    .font(.callout)
                    .foregroundColor(.gray)
                    .overlay {
                        DatePicker(selection: .init(get: {
                            return task.date ?? .init()
                        }, set: { value in
                            task.date = value
                            save()
                        }), displayedComponents:[.hourAndMinute]) {
                            
                        }
                        .labelsHidden()
                        .offset(x:100)
                    }
                
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            if (task.title ?? "").isEmpty {
                showKeyboard = true
            }
        }
        .onChange(of: env.scenePhase) { newValue in
            if newValue != .active {
                removeEmptyTask()
                save()
            }
        }
    }
    func save() {
        do {
            try env.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeEmptyTask() {
        if (task.title ?? "").isEmpty {
            env.managedObjectContext.delete(task)
        }
    }
}
