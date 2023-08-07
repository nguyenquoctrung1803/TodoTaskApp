//
//  TaskType.swift
//  ToDoTask
//
//  Created by Trung Nguyễn Quốc on 05/08/2023.
//

import Foundation


struct TaskType {
    let symbolName: String
    let typename: String
}



struct Task {
    var taskName: String
    var taskDescription: String
    var seconds: Int
    var taskType: TaskType
    var timeStamp: Double

}


enum CountDownState {
    case suspended
    case running
    case paused
}
