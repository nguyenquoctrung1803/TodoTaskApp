//
//  File.swift
//  ToDoTask
//
//  Created by Trung Nguyễn Quốc on 05/08/2023.
//

import Foundation


class TaskViewModel {
    
    //MARK: - Variable
    private var task : Task!
    
    private var taskType: [TaskType] = [
        TaskType(symbolName: "star", typename: "Priority"),
        TaskType(symbolName: "iphone", typename: "Develop"),
        TaskType(symbolName: "gamecontroller", typename: "Gaming"),
        TaskType(symbolName: "wand.and.stars.inverse", typename: "Editing")
    ]
    
    private var selectedIndex = -1 {
        didSet {
            self.task.taskType = getTaskType()[selectedIndex]
        }
    }
    
    private var hours = Box(0)
    private var minutes = Box(0)
    private var seconds = Box(0)
    
    
    
    //MARK: - init
    
    init () {
        task = Task(taskName: "", taskDescription: "", seconds: 0, taskType: .init(symbolName: "", typename: ""), timeStamp: 0)
    }
    //MARK: - Functions
    
    func setSelectedIndex (to value: Int) {
        self.selectedIndex = value
    }
    
    func setTaskName( to value: String) {
        self.task.taskName = value
    }
    
    func setTaskDescription( to value: String) {
        self.task.taskDescription = value
    }
    
    func getSelectedIndex() -> Int {
        self.selectedIndex
    }
    
    func getTask () -> Task {
        return self.task
    }
    
    func getTaskType () -> [TaskType] {
        return self.taskType
    }
    
    func setHours(to value: Int) {
        self.hours.value = value
    }
    
    func setMinutes(to value: Int) {
        var newMinutes = value
        if ( value >= 60) {
            newMinutes -= 60
            hours.value += 1
        }
        self.minutes.value = value
    }
    
    func setSeconds(to value: Int) {
        var newSeconds = value
        if ( value >= 60) {
            newSeconds -= 60
            minutes.value += 1
        }
        if (minutes.value >= 60) {
            minutes.value -= 60
            hours.value += 1
        }
        self.seconds.value = value
    }
    
    func getHours() -> Box<Int> {
        return self.hours
    }
    
    func getMinutes() -> Box<Int> {
        return self.minutes
    }
    
    func getSeconds() -> Box<Int> {
        return self.seconds
    }
    
    func computeSeconds() {
        self.task.seconds = (hours.value * 3600) + (minutes.value * 60) + seconds.value
        self.task.timeStamp = Date().timeIntervalSince1970
    }
    
    func isTaskValid () -> Bool {
        if (!task.taskName.isEmpty && !task.taskDescription.isEmpty && selectedIndex != -1 && (self.seconds.value > 0 || self.minutes.value > 0 || self.hours.value > 0 )) {
            return true
        }else {
            return false
        }
    }
    
    
}
