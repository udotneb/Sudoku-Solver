//
//  MinHeap.swift
//  Sodoku Solver
//
//  Created by Benjamin Ulrich on 6/7/18.
//  Copyright © 2018 Benjamin Ulrich. All rights reserved.
//

import Foundation

public class MinHeap {
    var mainLst: [Int] = []
    init() {
    }
    
    func swim(x: Int) {
        
    }
    
    func sink(x: Int) {
        
    }
    
    func changePriority(x: Int) {
        sink(x: x)
        swim(x: x)
    }
    
    func popTop() -> Int {
        return 1
    }
    
}
