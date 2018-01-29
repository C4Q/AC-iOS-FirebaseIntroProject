//
//  FirebaseAPIClient.swift
//  TaskList-ClassDemo
//
//  Created by C4Q  on 1/29/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

typealias TasksCallback = ([Task]?, Error?) -> Void

enum AppError: Error {
    case invalidChildren
    case invalidValue
}

class FirebaseAPIClient {
    static let manager = FirebaseAPIClient()
    private init() {}
    func login(with email: String, and password: String, completion: @escaping (User?, Error?) -> Void) {        
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    func createAccount(with email: String, and password: String, completion: @escaping AuthResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func loadAllTasks(completionHanlder: @escaping ([Task]?, Error?) -> Void) {
        let ref = Database.database().reference().child("tasks")
        ref.observe(.value){(snapShot: DataSnapshot) in
            guard let childSnapShots = snapShot.children.allObjects as? [DataSnapshot] else {
                completionHanlder(nil, AppError.invalidChildren)
                return
            }
            var allTasks = [Task]()
            for snap in childSnapShots {
                guard let rawJSON = snap.value else { continue }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: rawJSON, options: [])
                    let task = try JSONDecoder().decode(Task.self, from: jsonData)
                    allTasks.append(task)
                }
                catch {
                    print(error)
                }
            }
            completionHanlder(allTasks, nil)
        }
    }
    
    func createTestTasks() {
        let taskOne = Task(name: "Dishes", status: "Completed", estimatedTime: 30, rating: 3.2)
        let taskTwo = Task(name: "Laundry", status: "In progress", estimatedTime: 120, rating: 3.6)
        let taskThree = Task(name: "Homework", status: "Starting today", estimatedTime: Int.max, rating: 5.0)
        let ref = Database.database().reference().child("tasks")
        ref.childByAutoId().setValue(taskOne.toJSON())
        ref.childByAutoId().setValue(taskTwo.toJSON())
        ref.childByAutoId().setValue(taskThree.toJSON())
    }
    
    func logOutCurrentUser() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error)
        }
    }
}
