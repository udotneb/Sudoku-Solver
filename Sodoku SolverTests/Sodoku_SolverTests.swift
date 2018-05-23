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
    
    func test_Stack() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let x = Stack<Int>()
        x.addTop(x: 3)
        XCTAssert(x.removeTop() == 3)
        x.addTop(x: 4)
        x.addTop(x: 5)
        XCTAssert(x.removeTop() == 5)
        XCTAssert(x.removeTop() == 4)
    }
    
    func test_possibleNum1() {
        let x = Solver(x: [[0]])
        let b = [ [0, 4, 0],[1, 0, 3],[0, 5, 0]]
        let y = x.possibleNumbers(x: 0, y: 0, board: b)
        XCTAssert(!y.contains(1))
        XCTAssert(y.contains(9))
    }
    
    func test_possibleNum2() {
        let x = Solver(x: [[0]])
        let b = [ [0, 4, 0],[1, 0, 3],[0, 5, 0]]
        let yTwo = x.possibleNumbers(x: 1, y: 1, board: b)
        XCTAssert(!yTwo.contains(4))
        XCTAssert(!yTwo.contains(5))
        XCTAssert(!yTwo.contains(1))
        XCTAssert(!yTwo.contains(3))
        XCTAssert(yTwo.contains(2))
        XCTAssert(yTwo.contains(6))
    }
    
    func test_possibleNum3() {
        let b = [ [9, 4, 0],[1, 0, 3],[0, 5, 0]]
        let x = Solver(x: [[0]])
        let y = x.possibleNumbers(x: 1, y: 1, board: b)
        XCTAssert(!y.contains(9))
        let p = [0,0,0,0,0,0,0,0,0]
        var lst = [[0,0,0,0,0,0,0,0,0]]
        lst.append(p)
        lst.append(p)
        lst.append(p)
        lst.append(p)
        lst.append(p) //6
        lst.append([9,7,8,0,0,0,0,0,0])
        lst.append([6,0,0,0,0,0,0,5,0])
        lst.append([4,2,3,0,0,0,0,0,0])
        let j = x.possibleNumbers(x: 1, y: 7, board: lst)
        XCTAssert(j.contains(1))
        XCTAssert(!j.contains(9))
        XCTAssert(!j.contains(4))
        XCTAssert(!j.contains(3))
        XCTAssert(!j.contains(8))
        XCTAssert(!j.contains(5))
    }
    
    func test_Solver1() {
        var x = [[0, 4, 0, 0, 0, 0, 1, 7, 9]]
        x.append([0, 0, 2, 0, 0, 8, 0, 5, 4])
        x.append([0, 0, 6, 0, 0, 5, 0, 0, 8])
        x.append([0, 8, 0, 0, 7, 0, 9, 1, 0])
        x.append([0, 5, 0, 0, 9, 0, 0, 3, 0])
        x.append([0, 1, 9, 0, 6, 0, 0, 4, 0])
        x.append([3, 0, 0, 4, 0, 0, 7, 0, 0])
        x.append([5, 7, 0, 1, 0, 0, 2, 0, 0])
        x.append([9, 2, 8, 0, 0, 0, 0, 6, 0])
        let y = Solver(x: x)
        y.solve()
    }
    
    func test_Solver2() {
        var x = [[8, 0, 2, 0, 5, 0, 7, 0, 1]]
        x.append([0, 0, 7, 0, 8, 2, 4, 6, 0])
        x.append([0, 1, 0, 9, 0, 0, 0, 0, 0])
        x.append([6, 0, 0, 0, 0, 1, 8, 3, 2])
        x.append([5, 0, 0, 0, 0, 0, 0, 0, 9])
        x.append([1, 8, 4, 3, 0, 0, 0, 0, 6])
        x.append([0, 0, 0, 0, 0, 4, 0, 2, 0])
        x.append([0, 9, 5, 6, 1, 0, 3, 0, 0])
        x.append([3, 0, 8, 0, 9, 0, 6, 0, 7])
        let y = Solver(x: x)
        y.solve()
    }
    
    func test_Solver3() {
        var x = [[0, 0, 0, 7, 0, 0, 8, 0, 0]]
        x.append([0, 0, 6, 0, 0, 0, 0, 3, 1])
        x.append([0, 4, 0, 0, 0, 2, 0, 0, 0])
        x.append([0, 2, 4, 0, 7, 0, 0, 0, 0])
        x.append([0, 1, 0, 0, 3, 0, 0, 8, 0])
        x.append([0, 0, 0, 0, 6, 0, 2, 9, 0])
        x.append([0, 0, 0, 8, 0, 0, 0, 7, 0])
        x.append([8, 6, 0, 0, 0, 0, 5, 0, 0])
        x.append([0, 0, 2, 0, 0, 6, 0, 0, 0])
        let y = Solver(x: x)
        y.solve()
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
