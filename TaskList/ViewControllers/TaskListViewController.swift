//
//  ViewController.swift
//  TaskList
//
//  Created by Alexey Efimov on 28.03.2024.
//

import UIKit

final class TaskListViewController: UITableViewController {
    private let storeManager = StoreManager.shared
    private let cellID = "task"
    private var taskList: [ToDoTask] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        NavigationBarConfigurator.setupNavigationBar(
            for: self,
            title: "Task List",
            addAction:  #selector(addNewTask)
        )
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        taskList = storeManager.fetchData()
    }
    
    @objc private func addNewTask() {
        AlertPresenter.showAlert(
            on: self,
            withTitle: "New Task",
            andMessage: "What do you want to do?"
        ) { [weak self] inputText in
            guard let self else { return }
            guard let task = inputText, !task.isEmpty else { return }
            
            taskList = storeManager.save(new: task, in: taskList)
            
            let indexPath = IndexPath(row: taskList.count - 1, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }    
}

// MARK: - UITableViewDataSource
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            guard let self else { return }
                       
            taskList = storeManager.delete(by: indexPath.row, in: taskList)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        
        delete.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let task = taskList[indexPath.row]
        
        AlertPresenter.showAlert(
            on: self,
            withTitle: "Edit task",
            andMessage: "What do you want to do?",
            placeHolder: task.title
        ) { [weak self] inputText in
            guard let self else { return }
            guard let task = inputText, !task.isEmpty else { return }
            
            let updatedTaskList = storeManager.edit(task, by: indexPath.row, in: taskList)
            
            taskList = updatedTaskList
            
            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)

        }
        
    }
    
}
