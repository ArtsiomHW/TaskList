//
//  StoreManager.swift
//  TaskList
//
//  Created by Artem H on 12/14/24.
//

//import Foundation
import CoreData


final class StoreManager {
    
    static let shared = StoreManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

// MARK: — save, edit and delete
extension StoreManager {
    func save(new taskName: String, in taskList: [ToDoTask]) -> [ToDoTask] {
        
        let task = ToDoTask(context: persistentContainer.viewContext)
               
        task.title = taskName
        
        var updatedTaskList = taskList
        updatedTaskList.append(task)
        
        saveContext()
        return updatedTaskList
    }
    
    func delete(by index: Int, in taskList: [ToDoTask]) -> [ToDoTask] {
        let context = persistentContainer.viewContext
        
        let taskName = taskList[index]
        context.delete(taskName)
        
        var updatedTaskList = taskList
        updatedTaskList.remove(at: index)
        
        saveContext()
        return updatedTaskList
        
    }
    
    func edit(_ task: String, by index: Int, in taskList: [ToDoTask]) -> [ToDoTask] {
        taskList[index].title = task
        
        saveContext()
        
        return taskList

    }
}

// MARK: — fetchData
extension StoreManager {
    func fetchData() -> [ToDoTask] {
        let fetchRequest = ToDoTask.fetchRequest()
        var fetchTasks: [ToDoTask] = []
        
        do {
            fetchTasks = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        return fetchTasks
    }
}
