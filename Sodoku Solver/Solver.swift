//
//  Solver.swift
//  Sodoku Solver
//
//  Created by Benjamin Ulrich on 5/15/18.
//  Copyright © 2018 Benjamin Ulrich. All rights reserved.
//

import Foundation

public class Solver {
    var board: [[Int]]
    var usedStack: Stack<[Int]> //orderd as [x, y]
    var nextStack: Stack<[Int]> //ordered as [x, y, val]
    var count: Int
    init(x: [[Int]]) {
        self.board = x
        self.usedStack = Stack<[Int]>()
        self.nextStack = Stack<[Int]>()
        self.count = 0
    }
    
    public func solve() -> [[Int]]{
        if (!initialCheck()) {
            return [[-1]]
        }
        var currCoor: [Int] = [0,0]
        while (true) {
            let x = currCoor[0]
            let y = currCoor[1]
            
            if (board[y][x] == 0) {
                count += 1
                //if not already a set value
                for i in possibleNumbers(x: x, y: y, board: self.board) {
                    self.nextStack.addTop(x: [x, y, i])
                }
                
                let nextCoor = self.nextStack.removeTop()
                while (compareCoor(lst1: currCoor, lst2: nextCoor) > 0) {
                    //backtrack
                    var nextUsed = self.usedStack.removeTop()
                    currCoor[0] = nextUsed[0]
                    currCoor[1] = nextUsed[1]
                    board[currCoor[1]][currCoor[0]] = 0
                }
                //set number
                self.board[nextCoor[1]][nextCoor[0]] = nextCoor[2]
                self.usedStack.addTop(x: [nextCoor[0], nextCoor[1]])
                currCoor[0] = nextCoor[0]
                currCoor[1] = nextCoor[1]
            }
            //if last square
            if (currCoor[0] == 8 && currCoor[1] == 8) {
                print(self.count)
                return self.board
            }
            //increment counter
            if (currCoor[0] + 1 == 9) {
                currCoor[0] = 0
                currCoor[1] += 1
            } else {
                currCoor[0] += 1
            }
        }
    }
    
    private func compareCoor(lst1: [Int], lst2: [Int]) -> Int {
        //returns 1 if lst1 > lst2, 0 if ==, -1 if <
        if (lst1[1] > lst2[1]) {
            return 1
        } else if (lst1[1] < lst2[1]) {
            return -1
        } else if (lst1[0] > lst2[0]) {
            return 1
        } else if (lst1[0] < lst2[0]) {
            return -1
        }
        return 0
    }
    
    public func possibleNumbers(x: Int, y: Int, board: [[Int]]) -> Set<Int> {
        //returns a list with all missing words in box, horiz, vertical
        var lst = Set<Int>()
        for i in 1...9 {
            lst.insert(i)
        }
        checkHorizontal(x: x, y: y, lst: &lst, board: board)
        checkVertical(x: x, y: y, lst: &lst, board: board)
        checkBox(x: x, y: y, lst: &lst, board: board)
        return lst
    }
    
    private func checkHorizontal(x: Int, y: Int, lst: inout Set<Int>, board: [[Int]]) {
        //mutates list removing all numbers in row
        for i in board[y] {
            lst.remove(i)
        }
    }
    
    private func checkVertical(x: Int, y: Int, lst: inout Set<Int>, board: [[Int]]) {
        //mutates list removing all numbers in column
        for i in 0..<board.count {
            let num = board[i][x]
            lst.remove(num)
        }
    }
    
    private func checkBox(x: Int, y: Int, lst: inout Set<Int>, board: [[Int]]) {
        //mutates list removing all numbers in box
        //BOARD MUST BE MULTIPLE OF 3
        let xBoard = x / 3
        let yBoard = y / 3
        for i in (yBoard * 3)...(yBoard * 3 + 2) {
            for k in (xBoard * 3)...(xBoard * 3 + 2) {
                lst.remove(board[i][k])
            }
        }
    }
    
    private func initialCheck() -> Bool {
        for i in 0...8 {
            for k in 0...8 {
                let x = i
                let y = k
                let horiz = checkHorizontalInit(x: x, y: y, board: board)
                let vert = checkVerticalInit(x: x, y: y, board: board)
                let box = checkBoxInit(x: x, y: y, board: board)
                let flag = horiz && vert && box
                if (!flag) {
                    return flag
                }
            }
        }
        return true
    }
    
    private func checkHorizontalInit(x: Int, y: Int, board: [[Int]]) -> Bool {
        //mutates list removing all numbers in row
        var x = Set<Int>()
        for i in board[y] {
            if (x.contains(i) && i != 0) {
                return false
            }
            x.insert(i)
        }
        return true
    }
    
    private func checkVerticalInit(x: Int, y: Int, board: [[Int]]) -> Bool {
        //mutates list removing all numbers in column
        var s = Set<Int>()
        for i in 0..<board.count {
            let num = board[i][x]
            if (num != 0 && s.contains(num)) {
                return false
            }
            s.insert(num)
        }
        return true
    }
    
    private func checkBoxInit(x: Int, y: Int, board: [[Int]]) -> Bool {
        //mutates list removing all numbers in box
        //BOARD MUST BE MULTIPLE OF 3
        let xBoard = x / 3
        let yBoard = y / 3
        var x = Set<Int>()
        for i in (yBoard * 3)...(yBoard * 3 + 2) {
            for k in (xBoard * 3)...(xBoard * 3 + 2) {
                let num = board[i][k]
                if (num != 0 && x.contains(num)) {
                    return false
                }
                x.insert(num)
            }
        }
        return true
    }
    
    
    
    
    

}
