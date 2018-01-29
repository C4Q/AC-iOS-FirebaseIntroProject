//
//  TasksTableViewController.swift
//  TaskList-ClassDemo
//
//  Created by C4Q  on 1/29/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class TasksTableViewController: UITableViewController {
    
    var tasks = [Task]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        FirebaseAPIClient.manager.loadAllTasks{(tasks, error) in
            if let error = error { print(error); return }
            guard let onlineTasks = tasks else { return }
            self.tasks = onlineTasks
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task Cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.name
        let display = "status: \(task.status), rating: \(task.rating), estimated time: \(task.estimatedTime)"
        cell.detailTextLabel?.text = display
        return cell
    }
}
