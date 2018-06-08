//
//  Sodoku_SolverTests.swift
//  Sodoku SolverTests
//
//  Created by Benjamin Ulrich on 5/15/18.
//  Copyright © 2018 Benjamin Ulrich. All rights reserved.
//

import XCTest
@testable import Sodoku_Solver

class Sodoku_SolverTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_fastSolve() {
        var x = [[0, 0, 0, 1, 2, 3, 0, 0, 0]]
        x.append([0, 0, 0, 4, 5, 6, 0, 0, 0])
        x.append([0, 0, 0, 7, 8, 0, 0, 0, 0])
        x.append([0, 0, 0, 0, 0, 0, 0, 0, 0])
        x.append([0, 0, 0, 0, 0, 0, 0, 0, 0])
        x.append([0, 0, 0, 0, 0, 0, 0, 0, 0])
        x.append([0, 0, 0, 0, 0, 0, 0, 0, 0])
        x.append([0, 0, 0, 0, 0, 0, 0, 0, 0])
        x.append([0, 0, 0, 0, 0, 0, 0, 0, 0])
        let y = FastSolver(x: x)
        y.solve()
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
