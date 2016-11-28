//
//  TodoItem.swift
//  melissatjhia-pset5
//
//  Created by Melissa Tjhia on 28-11-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import Foundation
import UIKit

class TodoItem {
    
    private var _title: String
    var title: String {
        get {
            return self._title
        }
        set(titleValue) {
            self._title = titleValue
        }
    }
    
    private var _id: Int64
    var id: Int64 {
        get {
            return self._id
        }
    }
    
    private var _completed: Bool
    var completed: Bool {
        get {
            return self._completed
        }
        set(completedValue) {
            self._completed = completedValue
        }
    }
    
    private var _picture: NSObjectFileImage?
    var picture: NSObjectFileImage? {
        get {
            return self._picture
        }
        set(pictureValue) {
            self._picture = pictureValue
        }
    }
    
    private var _duration: Int?
    var duration: Int? {
        get {
            return self._duration
        }
        set(durationValue) {
            self._duration = durationValue
        }
    }
    
    private var _backgroundColor: UIColor?
    var backgroundColor: UIColor? {
        get {
            return self._backgroundColor
        }
        set(backgroundColorValue) {
            self._backgroundColor = backgroundColorValue
        }
    }
    
    private var _inProgress: Bool
    var inProgress: Bool {
        get {
            return self._inProgress
        }
        set(inProgressValue) {
            self._inProgress = inProgressValue
        }
    }
    
    private var _description: String?
    var description: String? {
        get {
            return self._description
        }
        set(descriptionValue) {
            self._description = descriptionValue
        }
    }
    
    init(taskValue: String, idValue: Int64) {
        self._title = taskValue
        self._id = idValue
        self._completed = false
        self._picture = nil
        self._duration = nil
        self._backgroundColor = nil
        self._inProgress = false
        self._description = nil
    }
}
