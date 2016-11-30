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
    
    private var _name: String
    var name: String {
        get {
            return self._name
        }
        set(nameValue) {
            self._name = nameValue
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

    init(name: String, id: Int64) {
        self._name = name
        self._id = id
        self._completed = false
    }
}
