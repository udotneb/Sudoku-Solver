//
//  Stack.swift
//  Sodoku Solver
//
//  Created by Benjamin Ulrich on 5/15/18.
//  Copyright © 2018 Benjamin Ulrich. All rights reserved.
//

import Foundation


public class Stack<T> {
    var array = [T]()
    init() {
        self.array = [T]()
    }
    
    func removeTop() -> T {
        let count = array.count
        if count == 0 {
            
        }
        return array.remove(at: count - 1)
    }
    
    func addTop(x: T) {
        array.append(x)
    }
    
    func peek() -> T? {
        if (array.count == 0) {
            
        }
        return array[array.count - 1]
    }
}
