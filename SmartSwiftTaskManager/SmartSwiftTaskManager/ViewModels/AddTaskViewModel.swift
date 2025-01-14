//
//  AddTaskViewModel.swift
//  SmartSwiftTaskManager
//
//  Created by Satyam Dixit on 14/01/25.
//


import Foundation
import CoreData

class AddTaskViewModel {

    private var coreDataManager: CoreDataManager
    private var taskToEdit: NSManagedObject?
    
    init(coreDataManager: CoreDataManager, task: NSManagedObject?) {
        self.coreDataManager = coreDataManager
        self.taskToEdit = task
    }
    
    // Save or update task logic
    func saveTask(title: String, description: String, dueDate: Date, priority: String, location: String) {
        if let task = taskToEdit {
            // Update the existing task with new data
            coreDataManager.updateTask(task, title: title, description: description, dueDate: dueDate, priority: priority, location: location)
        } else {
            // Create a new task if no task exists to edit
            let newTask = TaskModel(
                title: title,
                taskDescription: description,
                dueDate: dueDate,
                priority: priority,
                location: location
            )
            coreDataManager.saveTask(newTask)
        }
    }
}

