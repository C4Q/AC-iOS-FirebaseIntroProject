//
//  Task.swift
//  TaskList-ClassDemo
//
//  Created by C4Q  on 1/29/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation

struct Task: Codable {
    let name: String
    let status: String
    let estimatedTime: Int
    let rating: Double
    //Will convert into dictionary where keys are indicies
    //let arr: [String] = ["test", "strings", "are", "here"]    
    func toJSON() -> Any {
        let jsonData = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: jsonData, options: [])
    }
}
