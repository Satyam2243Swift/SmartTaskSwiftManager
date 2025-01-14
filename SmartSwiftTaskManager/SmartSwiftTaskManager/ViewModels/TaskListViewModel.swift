//
//  TaskListViewModel.swift
//  SmartSwiftTaskManager
//
//  Created by Satyam Dixit on 14/01/25.
//


import CoreData

class TaskListViewModel {
    private let coreDataManager: CoreDataManager
    var tasks: [NSManagedObject] = []
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    // Fetch tasks from CoreData
    func fetchTasks(completion: @escaping () -> Void) {
        self.tasks = coreDataManager.fetchTasks() // Get the tasks from CoreData
        completion() // Reload data callback
    }
    
    // Delete task from CoreData
    func deleteTask(_ task: NSManagedObject) {
        coreDataManager.deleteTask(task)
        fetchTasks { } // Refresh task list after deletion
    }
}

