//
//  CoreDataManager.swift
//  SmartSwiftTaskManager
//
//  Created by Satyam Dixit on 14/01/25.
//


import CoreData

protocol CoreDataManagerProtocol {
    func fetchTasks() -> [NSManagedObject]
    func saveTask(_ task: TaskModel) -> Bool
    func deleteTask(_ task: TaskModel) -> Bool
    func saveContext()
}

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SmartSwiftTaskManager")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveTask(_ task: TaskModel) {
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        let taskObject = NSManagedObject(entity: entity, insertInto: context)

        taskObject.setValue(task.title, forKey: "title")
        taskObject.setValue(task.taskDescription, forKey: "taskDescription")
        taskObject.setValue(task.dueDate, forKey: "dueDate")
        taskObject.setValue(task.priority, forKey: "priority")
        taskObject.setValue(task.location, forKey: "location")

        saveContext()
    }

    func fetchTasks() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }

    func deleteTask(_ task: NSManagedObject) {
        context.delete(task)
        saveContext()
    }
    
    // This method updates an existing task
    func updateTask(_ task: NSManagedObject, title: String, description: String, dueDate: Date, priority: String, location: String) {
        task.setValue(title, forKey: "title")
        task.setValue(description, forKey: "taskDescription")
        task.setValue(dueDate, forKey: "dueDate")
        task.setValue(priority, forKey: "priority")
        task.setValue(location, forKey: "location")
        saveContext()
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
            }
        }
    }
}

